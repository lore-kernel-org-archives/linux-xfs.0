Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1B56E7CBF
	for <xfs@oss.sgi.com>; Thu, 28 Mar 2013 11:48:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 05F3E30406B
	for <xfs@oss.sgi.com>; Thu, 28 Mar 2013 09:48:29 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id gdGWC7UHysn6UFAp for <xfs@oss.sgi.com>;
	Thu, 28 Mar 2013 09:48:29 -0700 (PDT)
Received: from relay2.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id ADA85A5077
	for <xfs@oss.sgi.com>; Thu, 28 Mar 2013 17:48:28 +0100 (CET)
Date: Thu, 28 Mar 2013 17:48:27 +0100
From: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] xfstests: remove unconditional setting of FSTYP
Message-ID: <20130328164827.GF29125@twin.jikos.cz>
References: <1364485147-27210-1-git-send-email-dsterba@suse.cz>
	<20130328163738.GE29125@twin.jikos.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130328163738.GE29125@twin.jikos.cz>
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
To: dsterba@suse.cz, xfs@oss.sgi.com

On Thu, Mar 28, 2013 at 05:37:38PM +0100, David Sterba wrote:
> On Thu, Mar 28, 2013 at 04:39:07PM +0100, David Sterba wrote:
> > Commit 3345d2150e9e672 ("xfstests: clean up and simply check CLI option
> > parsing") hardcodes the FSTYP to xfs, testing other filesystems fails
> > with
> > 
> > common.rc: Error: $TEST_DEV (/dev/sda5) is not a MOUNTED xfs filesystem
> > 
> > Signed-off-by: David Sterba <dsterba@suse.cz>
> 
> That's not a complete fix, I haven't noticed the automatic fs detection via
> blkid, however it does not work because HOSTOS is not set:

Simply because HOSTOS is used before common/config is called. There was
one more bug left, FSTYP is not exported so it is set correctly in 'check'
but is not propagated to the subshells with tests.

david

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
