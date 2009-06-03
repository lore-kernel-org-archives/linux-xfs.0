Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n53GeErp183884 for <xfs@oss.sgi.com>; Wed, 3 Jun 2009 11:40:16 -0500
Date: Wed, 3 Jun 2009 12:40:30 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] README: add hint on install-qa
Message-ID: <20090603164029.GA30759@infradead.org>
References: <1243976934-18008-1-git-send-email-rherndon@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1243976934-18008-1-git-send-email-rherndon@sgi.com>
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
To: Robert Herndon <rherndon@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, Jun 02, 2009 at 04:08:54PM -0500, Robert Herndon wrote:
> +    - install header files required to build xfstests' programs:
> +
> +        # cd <...>/xfsprogs
> +        # make install-qa
> +
> +        % cd <...>/xfstests
> +        % make xfstests
> +
> +      This creates the directory /usr/include/xfs and installs
> +      files there that are required to compile the programs in
> +      this directory.

Note that this is only required for loggen, and we're currently
discussing options how to get rid of this.

I would keep the patch on hold for now.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
