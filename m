Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B836D7CA0
	for <xfs@oss.sgi.com>; Thu, 26 May 2016 08:43:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 885C830404E
	for <xfs@oss.sgi.com>; Thu, 26 May 2016 06:43:00 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id g7DHDZ5CV8lWGjbn (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 26 May 2016 06:42:58 -0700 (PDT)
Date: Thu, 26 May 2016 06:42:57 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: remounting with "errors=remount-ro" in fstab fails.
Message-ID: <20160526134257.GA2272@infradead.org>
References: <5746FBD1.8010605@jvales.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5746FBD1.8010605@jvales.net>
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
To: Jan Vales <jan@jvales.net>
Cc: xfs@oss.sgi.com

The option was never actually supported.  We used to ignore unknown
options for remount only, I guess that's why it used to work for you.

So yes, you can safely remove the option.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
