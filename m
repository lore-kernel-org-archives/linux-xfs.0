Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D7BFA7F50
	for <xfs@oss.sgi.com>; Thu, 19 Sep 2013 08:30:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B3A648F8073
	for <xfs@oss.sgi.com>; Thu, 19 Sep 2013 06:30:33 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id BEGDmWA6B5NXwOMN for <xfs@oss.sgi.com>;
	Thu, 19 Sep 2013 06:30:32 -0700 (PDT)
Date: Thu, 19 Sep 2013 15:30:29 +0200
From: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] xfstests: fix set-default test in btrfs/001
Message-ID: <20130919133029.GG6810@twin.jikos.cz>
References: <1379537307-21681-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1379537307-21681-1-git-send-email-jbacik@fusionio.com>
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
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Wed, Sep 18, 2013 at 04:48:27PM -0400, Josef Bacik wrote:
> We were actually testing this improperly, there was a bug in the set default
> code so we weren't actually honoring the 0 subvolid properly.  To fix this we
> need to get the subvolid for the subvol we want to set as the default and use
> that in the command.  With this patch we now pass again with the fix for the 0
> subvolid.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
Tested-by: David Sterba <dsterba@suse.cz>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
