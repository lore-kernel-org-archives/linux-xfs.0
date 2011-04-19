Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3JFvv4d042794 for <xfs@oss.sgi.com>; Tue, 19 Apr 2011 10:57:58 -0500
Received: from test.thunk.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 57A7BC02EF1
	for <xfs@oss.sgi.com>; Tue, 19 Apr 2011 09:01:23 -0700 (PDT)
Received: from test.thunk.org (li9-11.members.linode.com [67.18.176.11]) by
	cuda.sgi.com with ESMTP id 5b8xFfvYkSbY0STm for
	<xfs@oss.sgi.com>; Tue, 19 Apr 2011 09:01:23 -0700 (PDT)
Date: Tue, 19 Apr 2011 12:01:14 -0400
From: "Ted Ts'o" <tytso@mit.edu>
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP related?)
Message-ID: <20110419160114.GE3030@thunk.org>
References: <E7438588-5C5A-42B9-9B6C-FADF7CAC6D3A@dilger.ca>
	<4EEEA16E-1FDB-4430-A372-8F8701196E4C@mit.edu>
	<20110418004040.GS21395@dastard>
	<6C89E159-A5F6-4A06-A3D2-273BE4CFB9B5@dilger.ca>
	<BANLkTin=WEpSf6ddiOMNMOpCPP-wiEttSw@mail.gmail.com>
	<20110419034455.GB23985@dastard>
	<BANLkTinjh968ECqAobQ677hnV5yzke1ncw@mail.gmail.com>
	<20110419074538.GG23985@dastard> <20110419140909.GD3030@thunk.org>
	<4DAD987F.5000506@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4DAD987F.5000506@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Andreas Dilger <adilger@dilger.ca>, Yongqiang Yang <xiaoqiangnk@gmail.com>, xfs-oss <xfs@oss.sgi.com>, "coreutils@gnu.org" <coreutils@gnu.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, =?iso-8859-1?Q?P=E1draig?= Brady <P@draigbrady.com>, Markus Trippelsdorf <markus@trippelsdorf.de>

On Tue, Apr 19, 2011 at 09:13:19AM -0500, Eric Sandeen wrote:
> 
> But I too am confused about Dave's assertion that it only reflects ondisk state when we have that pesky delalloc flag.
> 
> Whose idea was that, anyway? ;)
> 
> I'd certainly buy the argument that it -should- only reflect ondisk state, and we should nuke the delalloc flag from orbit, if we could, though.

I see three options of how we can clarify FIEMAP's semantics:

1) We define it as only reflecting ondisk state, and nuke the delalloc
flag from orbit.

2) We state that if the file is currently has unflushed pages in the
page cache, and FIEMAP_FLAG_SYNC is not passed, whether or not extents
return the DELALLOC flag or how they handle the UNWRITTEN flag is
undefined.

3) We state that FIEMAP is supposed to return information which
reflects the union of the on-disk and page cache state, with all that
this implies.

All of these are internally consistent definitions --- we need to
chose one, document, and then tell the shellutils folks what they
should do.

In the case of #1 and #2, we really need to implement support for
SEEK_HOLE/SEEK_DATA for userspace programs like cp who want to know
this information.

Do we all agree on the problem statement, at least?  If so, then we
can try to come consensus on what is the appropriate solution. 

    	   		     	     - Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
