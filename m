Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9ED7F7F3F
	for <xfs@oss.sgi.com>; Mon, 16 Sep 2013 10:44:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 24F76AC003
	for <xfs@oss.sgi.com>; Mon, 16 Sep 2013 08:44:33 -0700 (PDT)
Date: Mon, 16 Sep 2013 08:44:23 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS: Assertion failed: first <= last && last <
	BBTOB(bp->b_length), file: fs/xfs/xfs_trans_buf.c, line: 568
Message-ID: <20130916154423.GA455@infradead.org>
References: <52165830.8050006@redhat.com>
 <52325369.1070001@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52325369.1070001@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Thu, Sep 12, 2013 at 06:51:05PM -0500, Mark Tinguely wrote:
> The secret to tripping over the bug is run the test until fsstress
> fills the filesystem before removing the files. So an error
> handling?
> 
> I use the test:
> 
> #!/bin/sh
> 
> ltp/fsstress -z -s 1378390208 -fsymlink=1 -n9999999 -p4 -d /test2
> cd /test2
> sync
> rm -rf *
> 
> If your filesystem is smaller, decrease the -n to make the test faster.
> 
> I have still not gotten a core, though Michael Semon sent one.

It would be useful if we could wire this up for xfstests

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
