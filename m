Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 89ED07F4E
	for <xfs@oss.sgi.com>; Wed, 27 Nov 2013 19:43:35 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7558C8F8035
	for <xfs@oss.sgi.com>; Wed, 27 Nov 2013 17:43:32 -0800 (PST)
Received: from mail-ob0-f175.google.com (mail-ob0-f175.google.com
	[209.85.214.175]) by cuda.sgi.com with ESMTP id
	wdwRGd1NeplxVB9y (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 27 Nov 2013 17:43:31 -0800 (PST)
Received: by mail-ob0-f175.google.com with SMTP id uz6so8113371obc.6
	for <xfs@oss.sgi.com>; Wed, 27 Nov 2013 17:43:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20131125134301.GA30189@infradead.org>
References: <1385379154-3802-1-git-send-email-zwu.kernel@gmail.com>
	<1385379154-3802-2-git-send-email-zwu.kernel@gmail.com>
	<20131125134301.GA30189@infradead.org>
Date: Thu, 28 Nov 2013 09:43:30 +0800
Message-ID: <CAEH94LhDRqD6OTxHeEP38LLWuYn92ziCrLcfzmtxLiUP=fjpOg@mail.gmail.com>
Subject: Re: [RFC PATCH 1/4] xfs: adjust the interface of xfs_qm_vop_dqalloc()
From: Zhi Yong Wu <zwu.kernel@gmail.com>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>, xfstests <xfs@oss.sgi.com>

On Mon, Nov 25, 2013 at 9:43 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Mon, Nov 25, 2013 at 07:32:31PM +0800, Zhi Yong Wu wrote:
>> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>>
>> There isn't a parent inode or a name for O_TMPFILE support, but will pass
>> a struct xfs_mount to xfs_qm_vop_dqalloc(). So its interface need to be
>> adjusted in order that O_TMPFILE creation function can also use it.
>
> Yes, there is.   The tmpfile method gets the parent directory passed
> as it's first argument.
ok, will pass it in.

>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs



-- 
Regards,

Zhi Yong Wu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
