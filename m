Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8789C7CA2
	for <xfs@oss.sgi.com>; Tue, 13 Sep 2016 04:07:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3C1428F8039
	for <xfs@oss.sgi.com>; Tue, 13 Sep 2016 02:07:03 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id n4Prr4KlPpMQnUKx (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 13 Sep 2016 02:07:01 -0700 (PDT)
Date: Tue, 13 Sep 2016 11:06:57 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] [RFC] xfs: make xfs btree stats less huge
Message-ID: <20160913090657.gz75xuhjhb6645sd@redhat.com>
References: <1473755322-883-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1473755322-883-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

On Tue, Sep 13, 2016 at 06:28:42PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Embedding a switch statement in every btree stats inc/add adds a lot
> of code overhead to the core btree infrastructure paths. Stats are
> supposed to be small and lightweight, but the btree stats have
> become big and bloated as we've added more btrees. It needs fixing
> because the reflink code will just add more overhead again.

Talking about stats, is there any documentation for that? I was using the log
stats while working on the fail_at_unmount hang, and I couldn't find anything
other than looking into the code to see what each number means.

Cheers

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
