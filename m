Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4E0317F3F
	for <xfs@oss.sgi.com>; Mon, 16 Sep 2013 18:20:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 37DA48F8065
	for <xfs@oss.sgi.com>; Mon, 16 Sep 2013 16:20:48 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 0Wn0moQDVDTz8nKL for <xfs@oss.sgi.com>;
	Mon, 16 Sep 2013 16:20:47 -0700 (PDT)
Message-ID: <5237924B.4030304@sandeen.net>
Date: Mon, 16 Sep 2013 18:20:43 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH, RFC] xfstests: add d_type checking to fsstress
References: <52377E50.3040907@redhat.com> <20130916225550.GG19103@dastard>
In-Reply-To: <20130916225550.GG19103@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 9/16/13 5:55 PM, Dave Chinner wrote:
> On Mon, Sep 16, 2013 at 04:55:28PM -0500, Eric Sandeen wrote:
>> This patch adds a "-D" switch to fsstress so that every time
>> we call readdir, we stat the dentry & compare it's st_mode
>> to the d_type.
>>
>> If -D is specified only once, it ignores DT_UNKNOWN.  If specified
>> twice, it considers DT_UNKNOWN to be an error.
> 
> Hmmmm. DT_UNKNOWN is actually a valid type on disk right through to the
> userspace interface. I can't think of why we'd want to consider it
> invalid, especially as right now xfs_repair siply zeros the field
> when recreating directory entries...

well, I didn't know that last part.  (but why do that?)

I was thinking along the lines of DT_UNKNOWN returns meaning
"this fs doesn't support d_type."

"If the file type could not be determined, the value DT_UNKNOWN is returned in d_type."

What d_type-grokking fs can't determine its file types?

-Eric

> Cheers,
> 
> Dave.
> 
>> +void test_d_type(int opno, pathname_t *f, struct dirent64 *de)
>> +{
>> +	struct stat64 sb;
>> +	char path[PATH_MAX];
>> +
>> +	snprintf(path, PATH_MAX, "%s/%s", f->path, de->d_name);
>> +
>> +	/* Don't check ./. or ./.. */
>> +	if (!strncmp(path, "./.", 3))
>> +		return;
> 
> . and .. should have the values of DT_UNKNOWN or DT_DIR. They are
> the only valid values for these entries.
> 
>> +
>> +	if (lstat64(path, &sb)) {
>> +		printf("%d/%d: getdents - can't stat %s\n",
>> +			procid, opno, path);
>> +	} else {
>> +		int bad_d_type = 0;
>> +
>> +		switch (de->d_type) {
>> +			case DT_BLK:
>> +				if (!S_ISBLK(sb.st_mode))
>> +					bad_d_type++;
>> +				break;
>> +			case DT_CHR:
>> +				if (!S_ISCHR(sb.st_mode))
>> +					bad_d_type++;
>> +				break;
>> +			case DT_DIR:
>> +				if (!S_ISDIR(sb.st_mode))
>> +					bad_d_type++;
>> +				break;
>> +			case DT_FIFO:
>> +				if (!S_ISFIFO(sb.st_mode))
>> +					bad_d_type++;
>> +				break;
>> +			case DT_LNK:
>> +				if (!S_ISLNK(sb.st_mode))
>> +					bad_d_type++;
>> +				break;
>> +			case DT_REG:
>> +				if (!S_ISREG(sb.st_mode))
>> +					bad_d_type++;
>> +				break;
>> +			case DT_SOCK:
>> +				if (!S_ISSOCK(sb.st_mode))
>> +					bad_d_type++;
>> +				break;
>> +			case DT_UNKNOWN:
>> +				if (verify_d_type > 1)
>> +					bad_d_type++;
>> +			break;
>> +		}
> 
> And DT_WHT? That's defined on disk and in the user interface ;)
> 
> i.e. this will not do the right thing with an unknown de->d_type.
> 
> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
