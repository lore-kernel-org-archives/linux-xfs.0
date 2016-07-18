Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 15AEF7CA0
	for <xfs@oss.sgi.com>; Mon, 18 Jul 2016 15:18:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 76B20AC002
	for <xfs@oss.sgi.com>; Mon, 18 Jul 2016 13:18:41 -0700 (PDT)
Received: from mail02.iobjects.de (mail02.iobjects.de [188.40.134.68]) by
	cuda.sgi.com with ESMTP id bBYZ8QXCgMlIADVt (version=TLSv1.2
	cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 18 Jul 2016 13:18:38 -0700 (PDT)
Subject: Re: xfs_vm_releasepage() causing BUG at free_buffer_head()
References: <143E2E5E912B4C348E8C62AA987F0506@alyakaslap>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Message-ID: <578D399C.1010006@applied-asynchrony.com>
Date: Mon, 18 Jul 2016 22:18:36 +0200
MIME-Version: 1.0
In-Reply-To: <143E2E5E912B4C348E8C62AA987F0506@alyakaslap>
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
To: Alex Lyakas <alex@zadarastorage.com>, xfs@oss.sgi.com

On 07/18/16 20:00, Alex Lyakas wrote:
> Greetings XFS community,
> 
> We have hit the following BUG [1].
> 
> This is in free_buffer_head():
> BUG_ON(!list_empty(&bh->b_assoc_buffers));
> 
> This is happening in a long-term mainline kernel 3.18.19.
> 
> Some googling revealed a possibly-related discussion at:
> http://comments.gmane.org/gmane.linux.file-systems/105093
> https://lkml.org/lkml/2016/5/30/1007
> except that in our case I don't see the "WARN_ON_ONCE(delalloc)" triggered.

Since you make it past the WARN_ONs that makes it look like this
very recent report from Friday:

http://oss.sgi.com/pipermail/xfs/2016-July/050199.html

Dave posted a patch in that thread which seems ot work fine and so
far hasn't set anything on fire, at least for me on 4.4.x.

cheers,
Holger

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
