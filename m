Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3K1ncUM064455 for <xfs@oss.sgi.com>; Tue, 19 Apr 2011 20:49:39 -0500
Received: from mail-pv0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 94A0B3F46EC
	for <xfs@oss.sgi.com>; Tue, 19 Apr 2011 18:53:05 -0700 (PDT)
Received: from mail-pv0-f181.google.com (mail-pv0-f181.google.com
	[74.125.83.181]) by cuda.sgi.com with ESMTP id TRm82P84HIz0Y8D4
	for <xfs@oss.sgi.com>; Tue, 19 Apr 2011 18:53:05 -0700 (PDT)
Received: by pvg13 with SMTP id 13so264770pvg.26
	for <xfs@oss.sgi.com>; Tue, 19 Apr 2011 18:53:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110419160114.GE3030@thunk.org>
References: <E7438588-5C5A-42B9-9B6C-FADF7CAC6D3A@dilger.ca>
	<4EEEA16E-1FDB-4430-A372-8F8701196E4C@mit.edu>
	<20110418004040.GS21395@dastard>
	<6C89E159-A5F6-4A06-A3D2-273BE4CFB9B5@dilger.ca>
	<BANLkTin=WEpSf6ddiOMNMOpCPP-wiEttSw@mail.gmail.com>
	<20110419034455.GB23985@dastard>
	<BANLkTinjh968ECqAobQ677hnV5yzke1ncw@mail.gmail.com>
	<20110419074538.GG23985@dastard> <20110419140909.GD3030@thunk.org>
	<4DAD987F.5000506@sandeen.net> <20110419160114.GE3030@thunk.org>
Date: Wed, 20 Apr 2011 09:53:04 +0800
Message-ID: <BANLkTinHsYgLbGBTnjRD1cJ0HAJXdebW-w@mail.gmail.com>
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP related?)
From: Yongqiang Yang <xiaoqiangnk@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ted Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger@dilger.ca>, Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>, "coreutils@gnu.org" <coreutils@gnu.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigbrady.com>, Markus Trippelsdorf <markus@trippelsdorf.de>

On Wed, Apr 20, 2011 at 12:01 AM, Ted Ts'o <tytso@mit.edu> wrote:
> On Tue, Apr 19, 2011 at 09:13:19AM -0500, Eric Sandeen wrote:
>>
>> But I too am confused about Dave's assertion that it only reflects ondis=
k state when we have that pesky delalloc flag.
>>
>> Whose idea was that, anyway? ;)
>>
>> I'd certainly buy the argument that it -should- only reflect ondisk stat=
e, and we should nuke the delalloc flag from orbit, if we could, though.
>
> I see three options of how we can clarify FIEMAP's semantics:
>
> 1) We define it as only reflecting ondisk state, and nuke the delalloc
> flag from orbit.
>
> 2) We state that if the file is currently has unflushed pages in the
> page cache, and FIEMAP_FLAG_SYNC is not passed, whether or not extents
> return the DELALLOC flag or how they handle the UNWRITTEN flag is
> undefined.
>
> 3) We state that FIEMAP is supposed to return information which
> reflects the union of the on-disk and page cache state, with all that
> this implies.
>
> All of these are internally consistent definitions --- we need to
> chose one, document, and then tell the shellutils folks what they
> should do.
>
> In the case of #1 and #2, we really need to implement support for
> SEEK_HOLE/SEEK_DATA for userspace programs like cp who want to know
> this information.
>
> Do we all agree on the problem statement, at least? =A0If so, then we
> can try to come consensus on what is the appropriate solution.

I agree on the problem statement.  Users need to know what FIEMAP
returns definitely.

It seems that Dave is looking at the problem from a different view.

Dave thinks that FIEMAP returns where data exists on disk finally.
Then there are 2 possibilities: unknown and known.  delayed extent is
unknown and others are known.  Although we know where data in
unwritten extent exist finally on disk, we cannot know whether or not
it is being in memory.  However we know data in delayed extent is in
memory. it sounds strange.

>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 -=
 Ted
>



-- =

Best Wishes
Yongqiang Yang

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
