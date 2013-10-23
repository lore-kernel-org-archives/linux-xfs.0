Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 149C57F37
	for <xfs@oss.sgi.com>; Wed, 23 Oct 2013 11:41:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A5448AC008
	for <xfs@oss.sgi.com>; Wed, 23 Oct 2013 09:41:42 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 8YW9Y51bj0YcKLPO for
	<xfs@oss.sgi.com>; Wed, 23 Oct 2013 09:41:41 -0700 (PDT)
Date: Thu, 24 Oct 2013 00:41:36 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] xfstests btrfs/020: test device replace on RO btrfs
Message-ID: <20131023164136.GI2675@dhcp-13-216.nay.redhat.com>
References: <1382527446-16053-1-git-send-email-eguan@redhat.com>
	<5267F88E.1010607@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5267F88E.1010607@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Wed, Oct 23, 2013 at 11:25:50AM -0500, Eric Sandeen wrote:
> On 10/23/13 6:24 AM, Eryu Guan wrote:
> > btrfs replace on readonly fs should not be allowed.
> > 
> > Regression test case for commit:
> > bbb651e Btrfs: don't allow the replace procedure on read only filesystems
> > 
> > Signed-off-by: Eryu Guan <eguan@redhat.com>
> 
> Could you speed this up by just truncating the loop files to 256m, rather
> than writing 256m to each (for a total of 768m IO?)

Sure, and that does save much time, 7s -> 1s on my test box.

V2 will be coming soon.

Thanks for the review!

Eryu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
