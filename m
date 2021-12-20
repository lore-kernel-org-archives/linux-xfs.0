Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1752DC433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Dec 2021 19:58:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233576AbhLTT6o (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Dec 2021 14:58:44 -0500
Received: from sandeen.net ([63.231.237.45]:44682 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234048AbhLTT6m (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 20 Dec 2021 14:58:42 -0500
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 52E13147572;
        Mon, 20 Dec 2021 13:58:11 -0600 (CST)
Message-ID: <080cd926-2c97-636a-1e72-25d00adf9068@sandeen.net>
Date:   Mon, 20 Dec 2021 13:58:39 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Subject: Re: [PATCH v3 2/2] xfsdump: intercept bind mount targets
Content-Language: en-US
To:     Masayoshi Mizuma <msys.mizuma@gmail.com>,
        Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>
References: <20201103023315.786103-2-hsiangkao@redhat.com>
 <20201103153328.889676-1-hsiangkao@redhat.com> <YcCoyZcKnOTz1Waa@gabell>
From:   Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <YcCoyZcKnOTz1Waa@gabell>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 12/20/21 10:01 AM, Masayoshi Mizuma wrote:
> On Tue, Nov 03, 2020 at 11:33:28PM +0800, Gao Xiang wrote:
>> It's a bit strange pointing at some non-root bind mount target and
>> then actually dumping from the actual root dir instead.
>>
>> Therefore, instead of searching for the root dir of the filesystem,
>> just intercept all bind mount targets by checking whose ino # of
>> ".." is itself with getdents.
>>
>> Fixes: 25195ebf107d ("xfsdump: handle bind mount targets")
>> Cc: Eric Sandeen <sandeen@redhat.com>
>> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> 
> Hi,
> 
> This patch works for the filesystem which the inode number of the
> root directory is different from the root inode number of the
> filesystem without the bind mount.
> 
> Please feel free to add:
> 
>    Tested-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>

Great, thank you for the test results.

-Eric

> The log with the both of the patch:
> 
>    # xfs_io -i -c 'bulkstat_single root' /test/MNT1 | awk '/bs_ino = /{print $3}'
>    128
>    # stat --printf="%i\n" /test/MNT1
>    1024
>    # xfsdump -L session -M test -f /tmp/2176346.dump /test/MNT1
>    xfsdump: using file dump (drive_simple) strategy
>    xfsdump: version 3.1.9 (dump format 3.0) - type ^C for status and control
>    xfsdump: level 0 dump of localhost:/test/MNT1
>    xfsdump: dump date: Mon Dec 20 10:38:27 2021
>    xfsdump: session id: edec5c99-062b-41b8-a0c2-6c3c87d7ce75
>    xfsdump: session label: "session"
>    xfsdump: ino map phase 1: constructing initial dump list
>    xfsdump: ino map phase 2: skipping (no pruning necessary)
>    xfsdump: ino map phase 3: skipping (only one dump stream)
>    xfsdump: ino map construction complete
>    xfsdump: estimated dump size: 532800 bytes
>    xfsdump: /var/lib/xfsdump/inventory created
>    xfsdump: creating dump session media file 0 (media 0, file 0)
>    xfsdump: dumping ino map
>    xfsdump: dumping directories
>    xfsdump: dumping non-directory files
>    xfsdump: ending media file
>    xfsdump: media file size 1061824 bytes
>    xfsdump: dump size (non-dir files) : 0 bytes
>    xfsdump: dump complete: 3 seconds elapsed
>    xfsdump: Dump Summary:
>    xfsdump:   stream 0 /tmp/2176346.dump OK (success)
>    xfsdump: Dump Status: SUCCESS
> 
> Thanks!
> Masa
> 
>> ---
>> changes since v2 (Eric):
>>   - error out the case where the directory cannot be read;
>>   - In any case, stop as soon as we have found "..";
>>   - update the mountpoint error message and use i18n instead;
>>
>>   dump/content.c | 57 ++++++++++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 57 insertions(+)
>>
>> diff --git a/dump/content.c b/dump/content.c
>> index c11d9b4..c248e74 100644
>> --- a/dump/content.c
>> +++ b/dump/content.c
>> @@ -511,6 +511,55 @@ static bool_t create_inv_session(
>>   		ix_t subtreecnt,
>>   		size_t strmix);
>>   
>> +static bool_t
>> +check_rootdir(int fd,
>> +	      xfs_ino_t ino)
>> +{
>> +	struct dirent	*gdp;
>> +	size_t		gdsz;
>> +	bool_t		found = BOOL_FALSE;
>> +
>> +	gdsz = sizeof(struct dirent) + NAME_MAX + 1;
>> +	if (gdsz < GETDENTSBUF_SZ_MIN)
>> +		gdsz = GETDENTSBUF_SZ_MIN;
>> +	gdp = (struct dirent *)calloc(1, gdsz);
>> +	assert(gdp);
>> +
>> +	while (1) {
>> +		struct dirent *p;
>> +		int nread;
>> +
>> +		nread = getdents_wrap(fd, (char *)gdp, gdsz);
>> +		/*
>> +		 * negative count indicates something very bad happened;
>> +		 * try to gracefully end this dir.
>> +		 */
>> +		if (nread < 0) {
>> +			mlog(MLOG_NORMAL | MLOG_WARNING,
>> +_("unable to read dirents for directory ino %llu: %s\n"),
>> +			      ino, strerror(errno));
>> +			break;
>> +		}
>> +
>> +		/* no more directory entries: break; */
>> +		if (!nread)
>> +			break;
>> +
>> +		for (p = gdp; nread > 0;
>> +		     nread -= (int)p->d_reclen,
>> +		     assert(nread >= 0),
>> +		     p = (struct dirent *)((char *)p + p->d_reclen)) {
>> +			if (!strcmp(p->d_name, "..")) {
>> +				if (p->d_ino == ino)
>> +					found = BOOL_TRUE;
>> +				break;
>> +			}
>> +		}
>> +	}
>> +	free(gdp);
>> +	return found;
>> +}
>> +
>>   bool_t
>>   content_init(int argc,
>>   	      char *argv[],
>> @@ -1393,6 +1442,14 @@ baseuuidbypass:
>>   			      mntpnt);
>>   			return BOOL_FALSE;
>>   		}
>> +
>> +		if (!check_rootdir(sc_fsfd, rootstat.st_ino)) {
>> +			mlog(MLOG_ERROR,
>> +_("%s is not the root of the filesystem (bind mount?) - use primary mountpoint\n"),
>> +			     mntpnt);
>> +			return BOOL_FALSE;
>> +		}
>> +
>>   		sc_rootxfsstatp =
>>   			(struct xfs_bstat *)calloc(1, sizeof(struct xfs_bstat));
>>   		assert(sc_rootxfsstatp);
>> -- 
>> 2.18.1
>>
> 
