Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id ED28A7F47
	for <xfs@oss.sgi.com>; Fri, 15 Jan 2016 13:38:44 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 88CE3AC003
	for <xfs@oss.sgi.com>; Fri, 15 Jan 2016 11:38:44 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id kmkrJwbM2925vqar (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 15 Jan 2016 11:38:40 -0800 (PST)
Subject: Re: [PATCH 0/4] quota: add new quotactl Q_XGETQUOTA2
References: <568FEA2C.6080708@redhat.com>
	<20160109072600.GA21636@infradead.org>
	<20160111132617.GD6262@quack.suse.cz>
	<5693D33A.5090307@sandeen.net> <20160111162807.GK6262@quack.suse.cz>
	<5696D27A.9070700@sandeen.net> <20160115093507.GA15950@quack.suse.cz>
	<56992CD4.6030408@sandeen.net>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <56994ABE.8000607@redhat.com>
Date: Fri, 15 Jan 2016 13:38:38 -0600
MIME-Version: 1.0
In-Reply-To: <56992CD4.6030408@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>, Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, fsdevel <linux-fsdevel@vger.kernel.org>, xfs@oss.sgi.com

On 1/15/16 11:31 AM, Eric Sandeen wrote:

> My first lazy/hacky thought is "how terrible would it be to overload the
> quotactl syscall return value with quota ID for Q_GETQUOTA2 calls?"

Never mind, we can use all 32 bits of the unsigned ID, I think, so that
doesn't work.  (thanks Zach) :)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
