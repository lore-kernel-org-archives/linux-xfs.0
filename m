Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4E0E87F37
	for <xfs@oss.sgi.com>; Mon, 30 Nov 2015 10:16:44 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 31E3B304066
	for <xfs@oss.sgi.com>; Mon, 30 Nov 2015 08:16:44 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 4S34piFnVR2mf4tA (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 30 Nov 2015 08:16:43 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id AA5EF688
	for <xfs@oss.sgi.com>; Mon, 30 Nov 2015 16:16:42 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-132.bos.redhat.com [10.18.41.132])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id tAUGGgdq015138
	for <xfs@oss.sgi.com>; Mon, 30 Nov 2015 11:16:42 -0500
Date: Mon, 30 Nov 2015 11:16:41 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs_io: implement 'inode' command V5
Message-ID: <20151130161641.GE24765@bfoster.bfoster>
References: <1448552795-8794-1-git-send-email-cmaiolino@redhat.com>
	<20151130132217.GA24765@bfoster.bfoster>
	<20151130142622.GA27492@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151130142622.GA27492@redhat.com>
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
To: xfs@oss.sgi.com

On Mon, Nov 30, 2015 at 03:26:22PM +0100, Carlos Maiolino wrote:
> > 
> > I think we want "n:v" here since -n expects an argument, even if we
> > don't process the arg here.
> 
> Using getopt() to handle the -n argument, will make the inode command having 2
> different entry points for the same argument, i.e. the inode number. One as an
> argument for -n, and another as an argument for the command itself, like:
> 
> inode -n <num>
> inode <num>
> 
> We need to handle [num] as a stand-alone argument anyway, so, I just don't think
> we need to handle the same argument in different ways, which I achieved by not
> using [num] as a getopt() argument, but instead, handling [num] 'manually'
> according to the options used in getopt().
> 
> Not sure if I could be clear or get things more confused :)
> 

Sure, but I'm just referring to the error case when the user passes -n
without an argument. This should return an error but it doesn't at the
moment. I'm assuming that using "n:" would ensure the error message is
printed without disrupting the other code (e.g., continue to process
[num] manually even though "n:" is passed to getopt()). Is that the
case? If not, the error could be detected/handled manually as well.

Either way, a comment would also be useful here to document the special
handling as you note above.

> 
> > > +	if (ret_next && verbose)
> > > +		return command_usage(&inode_cmd);
> > > +
> > 
> > Why is this not supported? Hmm, I see that -n returns an inode number
> > and otherwise we print 0/1 or <inode>:<size> with -v. Perhaps this would
> > be easier if the command semantics/output were more consistent. E.g., 
> > 
> > "inode": print 0/1 based on largest inode size
> > "inode -v": print <ino>:<size> of largest inode
> > "inode <ino>": print <ino> if inode exists
> > "inode -v <ino>": print <ino>:<size> if inode exists
> 
> I thought about this, but I decided to not do it because the command looks a bit
> redundant for me when 'inode <ino' was returning 0 or 1. Returning the inode
> number itself, if it exists, makes more sense to have a -v option here too.
> 

Not sure I follow... AFAICT the command semantics change depending on
whether an inode number is passed or not (irrespective of -n and -v). If
not, we're looking to see if the largest inode is 32-bit or 64-bit. If
an inode number is passed, we're checking to see if an inode exists.

Brian

> > "inode -n <ino>": print <next ino> if next inode exists
> > "inode -nv <ino>": print <next ino>:<size> if next inode exists
> 
> Just FYI, if the 'next inode' doesn't exist (i.e. using the last fs inode as
> argument), the ioctl will return 0 in bstat.bs_ino, which, I choose to leave it
> as-is, and adding this observation to the man page, instead of returning a
> messag like "no more inodes in the fs".
> 
> I decided to leave it as-is, because for usage would be easier to parse a '0'
> return value from -n argument, than parsing an error message which has the same
> meaning of a zeroed return.
> 
> 
> Anyway, I'm going add -v to the another options, just please take a look at my
> replies regarding the 'inode -n' return value and the reason I didn't use
> getopt() to handle -n argument and if you agree or not, so I'll rewrite the
> patch to v6 based on this.
> 
> Cheers o>
> 
> -- 
> Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
