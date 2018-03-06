Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42520 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933055AbeCFXgN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Mar 2018 18:36:13 -0500
Subject: Re: [PATCH 6/5] libxfs-apply: add Signed-off-by:
References: <d81cf576-6082-008b-761e-82c487e6a87a@redhat.com>
 <12ef6721-1f1d-9dfa-507f-47e3d8143234@sandeen.net>
 <20180306233246.GR18989@magnolia>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <655fcd7d-83ff-cb4d-3f67-60fa876a94e8@redhat.com>
Date: Tue, 6 Mar 2018 17:36:12 -0600
MIME-Version: 1.0
In-Reply-To: <20180306233246.GR18989@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On 3/6/18 5:32 PM, Darrick J. Wong wrote:
>> Subject: [PATCH 6/5] libxfs-apply: add Signed-off-by:
> 
> Heh.  Everybody's doing it!
> 
> On Tue, Mar 06, 2018 at 05:24:16PM -0600, Eric Sandeen wrote:
>> Technically when a maintainer moves a patch from another project,
>> they should add their Signed-off-by: tag.  Pick up SOB info
>> from git-config, and add an option to override that value if
>> desired.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> --
>>
>> diff --git a/tools/libxfs-apply b/tools/libxfs-apply
>> index e7d7e0a..2957fa0 100755
>> --- a/tools/libxfs-apply
>> +++ b/tools/libxfs-apply
>> @@ -8,7 +8,7 @@ usage()
>>  	echo $*
>>  	echo
>>  	echo "Usage:"
>> -	echo "	libxfs-apply [--verbose] --source <repodir> --commit <commit_id>"
>> +	echo "	libxfs-apply [--verbose] [--sob <name/email>] --source <repodir> --commit <commit_id>"
>>  	echo "	libxfs-apply --patch <patchfile>"
>>  	echo
>>  	echo "libxfs-apply should be run in the destination git repository."
>> @@ -73,6 +73,7 @@ while [ $# -gt 0 ]; do
>>  	--source)	REPO=$2 ; shift ;;
>>  	--patch)	PATCH=$2; shift ;;
>>  	--commit)	COMMIT_ID=$2 ; shift ;;
>> +	--sob)		SIGNED_OFF_BY=$2 ; shift ;;
> 
> Heh.
> 
>>  	--verbose)	VERBOSE=true ;;
>>  	*)		usage ;;
>>  	esac
>> @@ -274,6 +275,20 @@ fixup_header_format()
>>  			print $0
>>  		}' > $_hdr.new
>>  
>> +	# Remove the last line if it contains only whitespace
>> +	sed -i '${/^ *$/d;}' $_hdr.new
> 
> '/^[[:space:]]*$/d' ?
> 
> Just in case my computer starts dumping tabs into the commit messages.

I guess - this is filtering what it's actually doing today.... but *shrug* ok.

>> +
>> +	# Add Signed-off-by: header if specified
>> +	if [ ! -z ${SIGNED_OFF_BY+x} ]; then 
>> +		echo "Signed-off-by: $SIGNED_OFF_BY" >> $_hdr.new
>> +	else	# get it from git config if present
>> +		SOB_NAME=`git config --get user.name`
>> +		SOB_EMAIL=`git config --get user.email`
>> +		if [ ! -z ${SOB_NAME+x} ]; then
>> +			echo "Signed-off-by: $SOB_NAME <$SOB_EMAIL>" >> $_hdr.new
> 
> I don't think it's necessary to add your sob if it's already on the
> kernel patch.

maybe not, but it doesn't hurt either, it shows the path of the patch over time.
Are you worried about an extra line?  I guess I'm not... and I sometimes use
different emails depending on the hat I'm wearing, so I'm not that excited about
figuring out fancy matching and exclusion here.

-Eric
