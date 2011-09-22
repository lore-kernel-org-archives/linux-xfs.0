Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8MGavll244029 for <xfs@oss.sgi.com>; Thu, 22 Sep 2011 11:36:58 -0500
Date: Thu, 22 Sep 2011 12:36:55 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2 v2][xfstests] Add test 257: Check proper FITRIM
	argument handling
Message-ID: <20110922163655.GA627@infradead.org>
References: <1315410523-23925-1-git-send-email-lczerner@redhat.com>
	<alpine.LFD.2.00.1109221136590.4968@dhcp-27-109.brq.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1109221136590.4968@dhcp-27-109.brq.redhat.com>
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
To: Lukas Czerner <lczerner@redhat.com>
Cc: xfs@oss.sgi.com, aelder@sgi.com

On Thu, Sep 22, 2011 at 11:37:32AM +0200, Lukas Czerner wrote:
> > +	# Btrfs is special and this test does not apply to it
> > +	if [ $bytes -le $(($fsize*512)) ] && [ $FSTYP != "btrfs" ]; then
> > +		status=1
> > +		echo "It seems that fs logic handling len argument overflows"
> > +	fi
>

Care to explain why btrfs is "special"?

Also I can't parse the sentence above in the echo line.

>
> > +	export MKFS_OPTIONS=$backup_mkfs_options

why backup?

Otherwise this looks reasonable to me?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
