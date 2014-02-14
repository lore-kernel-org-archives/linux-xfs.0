Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 197597F51
	for <xfs@oss.sgi.com>; Fri, 14 Feb 2014 10:39:28 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 00C178F8039
	for <xfs@oss.sgi.com>; Fri, 14 Feb 2014 08:39:27 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id ivFF9pDYjn91eK5H (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 14 Feb 2014 08:39:26 -0800 (PST)
Date: Fri, 14 Feb 2014 17:39:25 +0100
From: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] xfstests: test for atime-related mount options
Message-ID: <20140214163925.GW16073@twin.jikos.cz>
References: <1392305016-7424-1-git-send-email-koen.de.wit@oracle.com>
	<52FCF60F.6030703@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52FCF60F.6030703@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Koen De Wit <koen.de.wit@oracle.com>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Thu, Feb 13, 2014 at 10:42:55AM -0600, Eric Sandeen wrote:
> > +cat /proc/mounts | grep "$SCRATCH_MNT" | grep relatime >> $seqres.full
> > +[ $? -ne 0 ] && echo "The relatime mount option should be the default."
> 
> Ok, I guess "relatime" in /proc/mounts is from core vfs code and
> should be there for the foreseeable future, so seems ok.
> 
> But - relatime was added in v2.6.20, and made default in 2.6.30.  So
> testing older kernels may not go as expected; it'd probably be best to
> catch situations where relatime isn't available (< 2.6.20) or not
> default (< 2.6.30), by explicitly mounting with relatime, and skipping
> relatime/strictatime tests if that fails?

Is there some consensus what's the lowest kernel version to be supported
by xfstests? 2.6.32 is the lowest base for kernels in use today, so
worrying about anything older does not seem necessary.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
