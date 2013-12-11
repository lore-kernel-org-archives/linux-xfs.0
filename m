Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 487A57FF7
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 01:46:17 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3155D8F8039
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 23:46:17 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id stZwGlGk8fNc2RK5 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 10 Dec 2013 23:46:16 -0800 (PST)
Date: Tue, 10 Dec 2013 23:46:15 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 05/10] xfstests: do not unmount tmpfs during remount.
Message-ID: <20131211074615.GE19248@infradead.org>
References: <1386706321-15795-1-git-send-email-jayr@google.com>
	<1386706321-15795-6-git-send-email-jayr@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1386706321-15795-6-git-send-email-jayr@google.com>
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
To: Junho Ryu <jayr@google.com>
Cc: hughd@google.com, tytso@mit.edu, branto@redhat.com, xfs@oss.sgi.com

On Tue, Dec 10, 2013 at 12:11:56PM -0800, Junho Ryu wrote:
> Several tests unmount then re-mount the scratch filesystem, to check
> that the content is unchanged; but unmounting a tmpfs is designed to
> lose its content, which causes such tests to fail unnecessarily.  Add
> _scratch_remount(), which instead uses remount on a tmpfs to preserve
> its contents.  Also add _test_remount() to do the same for the test
> device.

All these tests don't make sense if you never unmount the filesystem.
Istead they should exit with _notrun for tmpfs.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
