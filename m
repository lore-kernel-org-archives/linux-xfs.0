Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A43DBC07E99
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Jul 2021 21:59:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 853DF6161F
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Jul 2021 21:59:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbhGHWC1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 8 Jul 2021 18:02:27 -0400
Received: from sandeen.net ([63.231.237.45]:44308 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229497AbhGHWC0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 8 Jul 2021 18:02:26 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 18BB1550;
        Thu,  8 Jul 2021 16:58:59 -0500 (CDT)
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <162528110904.38981.1853961990457189123.stgit@locust>
 <162528111450.38981.8857321675621059098.stgit@locust>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 1/1] xfs_admin: support label queries for mounted
 filesystems
Message-ID: <ac736821-83de-4bde-a1a1-d0d2711932d7@sandeen.net>
Date:   Thu, 8 Jul 2021 16:59:43 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <162528111450.38981.8857321675621059098.stgit@locust>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 7/2/21 9:58 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Adapt this tool to call xfs_io if the block device in question is
> mounted.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  db/xfs_admin.sh |   41 +++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 39 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/db/xfs_admin.sh b/db/xfs_admin.sh
> index 409975b2..21c9d71b 100755
> --- a/db/xfs_admin.sh
> +++ b/db/xfs_admin.sh
> @@ -8,9 +8,34 @@ status=0
>  DB_OPTS=""
>  REPAIR_OPTS=""
>  REPAIR_DEV_OPTS=""
> +IO_OPTS=""
>  LOG_OPTS=""
>  USAGE="Usage: xfs_admin [-efjlpuV] [-c 0|1] [-L label] [-O v5_feature] [-r rtdev] [-U uuid] device [logdev]"
>  
> +# Try to find a loop device associated with a file.  We only want to return
> +# one loopdev (multiple loop devices can attach to a single file) so we grab
> +# the last line and return it if it's actually a block device.

Not thrilled about the C&P here from spaceman, but I guess by choosing to
use bash long ago, that ship has kinda sailed.  (Sourcing another file
would be possible I guess but ... meh, oh well)

> +try_find_loop_dev_for_file() {
> +	local x="$(losetup -O NAME -j "$1" 2> /dev/null | tail -n 1)"
> +	test -b "$x" && echo "$x"
> +}
> +
> +try_find_mount_point_for_bdev() {
> +	local arg="$1"
> +
> +	# See if we can map the arg to a loop device
> +	loopdev="$(try_find_loop_dev_for_file "${arg}")"
> +	test -n "${loopdev}" && arg="${loopdev}"
> +
> +	if [ ! -b "${arg}" ]; then
> +		return 1
> +	fi
> +
> +	# If we find a mountpoint for the device, do a live query;
> +	# otherwise try reading the fs with xfs_db.
> +	findmnt -t xfs -f -n -o TARGET "${arg}" 2> /dev/null
> +}
> +
>  while getopts "c:efjlL:O:pr:uU:V" c
>  do
>  	case $c in
> @@ -18,8 +43,10 @@ do
>  	e)	DB_OPTS=$DB_OPTS" -c 'version extflg'";;
>  	f)	DB_OPTS=$DB_OPTS" -f";;
>  	j)	DB_OPTS=$DB_OPTS" -c 'version log2'";;
> -	l)	DB_OPTS=$DB_OPTS" -r -c label";;
> -	L)	DB_OPTS=$DB_OPTS" -c 'label "$OPTARG"'";;
> +	l)	DB_OPTS=$DB_OPTS" -r -c label";
> +		IO_OPTS=$IO_OPTS" -r -c label";;
> +	L)	DB_OPTS=$DB_OPTS" -c 'label "$OPTARG"'";
> +		IO_OPTS=$IO_OPTS" -c 'label -s "$OPTARG"'";;
>  	O)	REPAIR_OPTS=$REPAIR_OPTS" -c $OPTARG";;
>  	p)	DB_OPTS=$DB_OPTS" -c 'version projid32bit'";;
>  	r)	REPAIR_DEV_OPTS=" -r '$OPTARG'";;
> @@ -43,6 +70,16 @@ case $# in
>  			LOG_OPTS=" -l '$2'"
>  		fi
>  
> +		if [ -n "$IO_OPTS" ]; then
> +			mntpt="$(try_find_mount_point_for_bdev "$1")"
> +			if [ $? -eq 0 ]; then
> +				eval xfs_io -x -p xfs_admin $IO_OPTS "$mntpt"
> +				status=$?
> +				DB_OPTS=""
> +				REPAIR_OPTS=""
> +			fi
> +		fi

If I read this correctly, specifying either of "-l" or "-L" will now cause
the command to stop executing after the label... but only if it's mounted.
hm yup.

before, when mounted:

# sh db/xfs_admin.sh -lu /dev/pmem0p1
label = ""
UUID = 392591da-ca09-4d4d-8c17-eb8e97ec9f9a

after this patch:

# sh db/xfs_admin.sh -lu /dev/pmem0p1
label = ""

Also, I'm not sure this:

# mount /dev/pmem0p1 /mnt/test
# sh  db/xfs_admin.sh -lU generate  /dev/pmem0p1
label = ""
#

is really desirable; -U is just silently ignored if it's mounted?
Before the patch, this would have failed with an error.

I wonder if we need to error out on any non-mounted-compliant options, or
simply go ahead and pass non-label db opts to the next stage so it'll
error out as it did before.

Also this is fun behavior that exists today :(

# xfs_admin  -l  -U generate  /dev/pmem0p1
label = "foo"
xfs_admin: not in expert mode, writing disabled
# 

('-l' adds -r, overrides the -x and puts it into readonly mode) 

>  		if [ -n "$DB_OPTS" ]
>  		then
>  			eval xfs_db -x -p xfs_admin $LOG_OPTS $DB_OPTS "$1"
> 
