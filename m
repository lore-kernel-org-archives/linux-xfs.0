Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n67AWaxr138929 for <xfs@oss.sgi.com>; Tue, 7 Jul 2009 05:32:37 -0500
Received: from fgwmail7.fujitsu.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C536F1AFE2C0
	for <xfs@oss.sgi.com>; Tue,  7 Jul 2009 03:33:10 -0700 (PDT)
Received: from fgwmail7.fujitsu.co.jp (fgwmail7.fujitsu.co.jp [192.51.44.37])
	by cuda.sgi.com with ESMTP id oQ88IXO5Q4pzcWgM for
	<xfs@oss.sgi.com>; Tue, 07 Jul 2009 03:33:10 -0700 (PDT)
Received: from m4.gw.fujitsu.co.jp ([10.0.50.74])
	by fgwmail7.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id
	n67AX9UK001663
	for <xfs@oss.sgi.com> (envelope-from kosaki.motohiro@jp.fujitsu.com);
	Tue, 7 Jul 2009 19:33:09 +0900
Received: from smail (m4 [127.0.0.1])
	by outgoing.m4.gw.fujitsu.co.jp (Postfix) with ESMTP id 3D2E145DE6E
	for <xfs@oss.sgi.com>; Tue,  7 Jul 2009 19:33:09 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.fujitsu.co.jp [10.0.50.94])
	by m4.gw.fujitsu.co.jp (Postfix) with ESMTP id 12FEB45DE60
	for <xfs@oss.sgi.com>; Tue,  7 Jul 2009 19:33:09 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id E6AB81DB8037
	for <xfs@oss.sgi.com>; Tue,  7 Jul 2009 19:33:08 +0900 (JST)
Received: from m108.s.css.fujitsu.com (m108.s.css.fujitsu.com [10.249.87.108])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 97C941DB803F
	for <xfs@oss.sgi.com>; Tue,  7 Jul 2009 19:33:05 +0900 (JST)
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH] bump up nr_to_write in xfs_vm_writepage
In-Reply-To: <20090707101946.GB1934@infradead.org>
References: <bzyd48cc14d.fsf@fransum.emea.sgi.com>
	<20090707101946.GB1934@infradead.org>
Message-Id: <20090707193015.7DCD.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Date: Tue,  7 Jul 2009 19:33:04 +0900 (JST)
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Sandeen <sandeen@redhat.com>, kosaki.motohiro@jp.fujitsu.com, xfs mailing list <xfs@oss.sgi.com>, linux-mm@kvack.org, Olaf Weber <olaf@sgi.com>, "MASON, CHRISTOPHER" <CHRIS.MASON@oracle.com>

> On Tue, Jul 07, 2009 at 11:07:30AM +0200, Olaf Weber wrote:
> > If the nr_to_write calculation really yields a value that is too
> > small, shouldn't it be fixed elsewhere?
> 
> In theory it should.  But given the amazing feedback of the VM people
> on this I'd rather make sure we do get the full HW bandwith on large
> arrays instead of sucking badly and not just wait forever.

At least, I agree with Olaf. if you got someone's NAK in past thread,
Could you please tell me its url?




_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
