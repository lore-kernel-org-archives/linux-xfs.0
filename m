Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AD0AF7F37
	for <xfs@oss.sgi.com>; Tue, 23 Apr 2013 09:14:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 88F09304064
	for <xfs@oss.sgi.com>; Tue, 23 Apr 2013 07:14:51 -0700 (PDT)
Received: from imap.thunk.org (li9-11.members.linode.com [67.18.176.11]) by
	cuda.sgi.com with ESMTP id 4FCSl69YSsAzAwmk (version=TLSv1
	cipher=AES128-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 23 Apr 2013 07:14:50 -0700 (PDT)
Date: Tue, 23 Apr 2013 10:14:42 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v3 05/18] xfs: use ->invalidatepage() length argument
Message-ID: <20130423141442.GD31170@thunk.org>
References: <1365498867-27782-1-git-send-email-lczerner@redhat.com>
	<1365498867-27782-6-git-send-email-lczerner@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1365498867-27782-6-git-send-email-lczerner@redhat.com>
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
To: Lukas Czerner <lczerner@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Tue, Apr 09, 2013 at 11:14:14AM +0200, Lukas Czerner wrote:
> ->invalidatepage() aop now accepts range to invalidate so we can make
> use of it in xfs_vm_invalidatepage()
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> Cc: xfs@oss.sgi.com

To the xfs team,

Since half of this patch series modifies ext4 extensively, and changes
to the other file systems are relatively small, I plan to carry the
invalidatepage patch set in the ext4 tree for the next development
cycle (i.e., not the upcoming merge window, but the next one).  To
that end, it would be great if you take a look at this patch set and
send us an Acked-by signoff.

Thanks!!

						- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
