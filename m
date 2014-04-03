Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DF5C17F9C
	for <xfs@oss.sgi.com>; Thu,  3 Apr 2014 14:21:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CC75A8F8039
	for <xfs@oss.sgi.com>; Thu,  3 Apr 2014 12:21:47 -0700 (PDT)
Received: from mail-qa0-f45.google.com (mail-qa0-f45.google.com
	[209.85.216.45]) by cuda.sgi.com with ESMTP id 6wNgWKH6tdvKVFf0
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 03 Apr 2014 12:21:46 -0700 (PDT)
Received: by mail-qa0-f45.google.com with SMTP id cm18so683758qab.32
	for <xfs@oss.sgi.com>; Thu, 03 Apr 2014 12:21:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <533DB140.8010103@redhat.com>
References: <1395997399-3000-1-git-send-email-sedat.dilek@gmail.com>
	<20140328161806.GA31772@thunk.org> <20140331025148.GF16336@dastard>
	<20140401023711.GE4911@thunk.org> <20140401222823.GJ17603@dastard>
	<20140402142620.GA6901@thunk.org> <20140403011411.GL16336@dastard>
	<alpine.LFD.2.00.1404031102310.2124@localhost.localdomain>
	<CALCETrU=JWigDSv6ymepS2tjL+EkO98VDC03-RSPuhQVk3yvZA@mail.gmail.com>
	<20140403173504.GB23737@thunk.org> <533DB140.8010103@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 3 Apr 2014 12:21:25 -0700
Message-ID: <CALCETrVq1DfpyhThajc9FYA7NLWYt9oX4vadCDcqn+d26aALGA@mail.gmail.com>
Subject: Re: [Lsf] [PATCH] xfstests-bld: Simplify determination of number of
	CPUs in build-all
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: Theodore Ts'o <tytso@mit.edu>, xfs@oss.sgi.com, lsf@lists.linux-foundation.org, Sedat Dilek <sedat.dilek@gmail.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, =?ISO-8859-2?Q?Luk=E1=B9_Czerner?= <lczerner@redhat.com>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>

On Thu, Apr 3, 2014 at 12:06 PM, Eric Sandeen <sandeen@redhat.com> wrote:
> On 4/3/14, 11:35 AM, Theodore Ts'o wrote:
>
>>>  - There's an undocumented way to write results outside the source
>>> tree called RESULT_BASE.  It would be great if it were documented and
>>> spelled consistently.
>
> I'm not actually certain that it was intended to be used this way.
> See 1686f9ab "xfstests: Introduce a results directory"
> which explains just where this variable came from and what it's
> for...

Yeah.  A real solution should just create and overmount results.

Unfortunately, AFAICT it's currently impossible to create a mountpoint
with no underlying dentry or to overmount a symlink, so this can be a
bit awkward.

>>>  - SCRATCH_MNT needs to be in /etc/fstab.  I think that this should be
>>> changed or documented.  If the latter, then SCRATCH_DEV seems
>>> redundant.
>
> Hm, I've never needed SCRATCH_MNT in /etc/fstab...
>
>> The various test scripts do need to be able to find the device where
>> the file system lives, and parsing /etc/fstab would be awkward.  So if
>> your comment is that either the /etc/fstab entry shouldn't be
>> required, or the xfstests runtime environment should be able to derive
>> $SCRATCH_DEV automatically from $SCRATCH_MNT, or vice versa, instead
>
> I guess I don't know why you'd expect to derive one from the other...

Sigh.

If $SCRATCH_MNT is specified, then the line in /etc/fstab is
unnecessary.  If $SCRATCH_MNT is not specified, then /etc/fstab will
do the trick.

What does not work is specifying $SCRATCH_DIR [sic] but not adding an
fstab entry.  Oops.


--Andy

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
