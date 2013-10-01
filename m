Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E263F7F59
	for <xfs@oss.sgi.com>; Tue,  1 Oct 2013 09:40:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BF8E130406A
	for <xfs@oss.sgi.com>; Tue,  1 Oct 2013 07:40:55 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 1WaLBRA2sayFPnMp for <xfs@oss.sgi.com>;
	Tue, 01 Oct 2013 07:40:54 -0700 (PDT)
Date: Tue, 1 Oct 2013 16:40:47 +0200
From: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] xfstests/btrfs: do not test btrfs/010 with autodefrag
Message-ID: <20131001144047.GI18291@twin.jikos.cz>
References: <1379481475-10842-1-git-send-email-bo.li.liu@oracle.com>
	<20130927134544.GI18681@localhost.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130927134544.GI18681@localhost.localdomain>
Reply-To: dsterba@suse.cz
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
To: Josef Bacik <jbacik@fusionio.com>
Cc: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Fri, Sep 27, 2013 at 09:45:44AM -0400, Josef Bacik wrote:
> On Wed, Sep 18, 2013 at 01:17:55PM +0800, Liu Bo wrote:
> > btrfs/010 is going to create a fragmented file, however, with autodefrag
> > this is impossible, so just skip the test when we're with autodefrag.
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> 
> I'd rather you just strip out the autodefrag option if it is there and add it
> back once the test is done (or hell just remove it, mount, and add it back).

I think the test should be skipped if it does not make sense with a
specific mount option rather than temporarily removing it, because then
it looks like the test passes with the option altough it does not.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
