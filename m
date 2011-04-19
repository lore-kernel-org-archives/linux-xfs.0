Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3JE9dLp039704 for <xfs@oss.sgi.com>; Tue, 19 Apr 2011 09:09:39 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 087231EC0A3B
	for <xfs@oss.sgi.com>; Tue, 19 Apr 2011 07:13:05 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id zIOUiEIHUfQH1vCI for <xfs@oss.sgi.com>;
	Tue, 19 Apr 2011 07:13:05 -0700 (PDT)
Message-ID: <4DAD987F.5000506@sandeen.net>
Date: Tue, 19 Apr 2011 09:13:19 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP related?)
References: <76FFF648-CA02-494B-A862-566C66A8CB82@dilger.ca>
	<20110416005040.GP21395@dastard>
	<E7438588-5C5A-42B9-9B6C-FADF7CAC6D3A@dilger.ca>
	<4EEEA16E-1FDB-4430-A372-8F8701196E4C@mit.edu>
	<20110418004040.GS21395@dastard>
	<6C89E159-A5F6-4A06-A3D2-273BE4CFB9B5@dilger.ca>
	<BANLkTin=WEpSf6ddiOMNMOpCPP-wiEttSw@mail.gmail.com>
	<20110419034455.GB23985@dastard>
	<BANLkTinjh968ECqAobQ677hnV5yzke1ncw@mail.gmail.com>
	<20110419074538.GG23985@dastard> <20110419140909.GD3030@thunk.org>
In-Reply-To: <20110419140909.GD3030@thunk.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ted Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger@dilger.ca>, Yongqiang Yang <xiaoqiangnk@gmail.com>, xfs-oss <xfs@oss.sgi.com>, "coreutils@gnu.org" <coreutils@gnu.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigbrady.com>, Markus Trippelsdorf <markus@trippelsdorf.de>

On 4/19/11 9:09 AM, Ted Ts'o wrote:
> On Tue, Apr 19, 2011 at 05:45:38PM +1000, Dave Chinner wrote:
>> You are *not listening*. There is no #2. FIEMAP returns the extent
>> state _on disk_ at the time of the call.
> 
> Dave, you're being rather strident about your insistence about what
> FIEMAP's semantics are.  Part of the problem here is that it's *not*
> clear or settled.
> 
> If it really is the state _on_ _disk_, does XFS really have a DELALLOC
> bit _on_ _disk_?
> 
> 					- Ted
> 

no of course it doesn't....

But I too am confused about Dave's assertion that it only reflects ondisk state when we have that pesky delalloc flag.

Whose idea was that, anyway? ;)

I'd certainly buy the argument that it -should- only reflect ondisk state, and we should nuke the delalloc flag from orbit, if we could, though.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
