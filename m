Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BDE017F69
	for <xfs@oss.sgi.com>; Sun, 26 Jul 2015 11:19:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9BD5730404E
	for <xfs@oss.sgi.com>; Sun, 26 Jul 2015 09:19:23 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id YHFJOAjhN9cSEMmb (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 26 Jul 2015 09:19:22 -0700 (PDT)
Date: Sun, 26 Jul 2015 09:19:20 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] Prefix LIST_... macros to XFS_LIST_...
Message-ID: <20150726161920.GB29329@infradead.org>
References: <1436964412-12093-1-git-send-email-jtulak@redhat.com>
	<1436964412-12093-2-git-send-email-jtulak@redhat.com>
	<20150715235306.GT3902@dastard>
	<1131231186.27908155.1437030777674.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1131231186.27908155.1437030777674.JavaMail.zimbra@redhat.com>
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
To: Jan Tulak <jtulak@redhat.com>
Cc: xfs@oss.sgi.com

libxfs comes form the Linux kernel which uses these names,
so we shouldn't rename them either.

On various BSDS LIST* is used for different list macros, so the real
question is how we end up including those.

Can you post the compiler warnings you see without this patch?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
