Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5B48D29DF8
	for <xfs@oss.sgi.com>; Mon, 17 Jun 2013 19:13:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3A82C8F8049
	for <xfs@oss.sgi.com>; Mon, 17 Jun 2013 17:13:37 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id MWDC8cBJLmFP1EZ3 for
	<xfs@oss.sgi.com>; Mon, 17 Jun 2013 17:13:36 -0700 (PDT)
Message-ID: <51BFA62A.5040900@gmail.com>
Date: Tue, 18 Jun 2013 10:13:30 +1000
From: Mark Goodwin <goodwinos@gmail.com>
MIME-Version: 1.0
Subject: Re: definitions for /proc/fs/xfs/stat
References: <CAC2B=ZFP_Fg34aFpk857stgB7MGcrYs9tybRS-ttw1CXNeU41Q@mail.gmail.com>
	<504625587.1365681.1371255450937.JavaMail.root@redhat.com>
	<CAC2B=ZF+eMyNLPQmhA_onDPEUqgNfcgCdZVvobNH9pofvioN7Q@mail.gmail.com>
	<20130615020414.GB29338@dastard>
	<CAC2B=ZEUkd+ADnQLUKj9S-3rdo2=93WbW0tbLbwwHUvkh6v7Rw@mail.gmail.com>
	<CAC2B=ZGgr5WPWOEehHDHKekM8yHgQ3QS4HMzM8+j217AfEoPyQ@mail.gmail.com>
	<20130616001130.GE29338@dastard>
	<CAC2B=ZFZskLnp5baVJK+R1xrpOfTkr1QXpA9jyHvxfk5Wd4yDg@mail.gmail.com>
	<419435719.1662203.1371431489790.JavaMail.root@redhat.com>
In-Reply-To: <419435719.1662203.1371431489790.JavaMail.root@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Mark Seger <mjseger@gmail.com>
Cc: Nathan Scott <nathans@redhat.com>, xfs@oss.sgi.com

On 06/17/2013 11:11 AM, Nathan Scott wrote:
>> ok, I have a simple reproducer.  try out the following, noting you'll
>> obviously have to change the directory pointed to by dname:
>>
>> libc=ctypes.CDLL(ctypes.util.find_library('c'), use_errno=True)
>> falloc=getattr(libc, 'fallocate')
>>
>
> This is using the glibc fallocate wrapper - I have vague memories of an
> old libc which used to do per-page buffered writes providing a poor-mans
> implementation of fallocate, maybe somehow that older version/behaviour
> is being triggered.

Python probably tipped you into a posix_fallocate() bog hole - it writes
one byte to every block in the range offset .. offset+len as the portable
(but poor-man's) implementation of fallocate(). This combined with your
controller cache could explain the unexpected i/o.

See glibc:sysdeps/posix/posix_fallocate.c

-- Mark

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
