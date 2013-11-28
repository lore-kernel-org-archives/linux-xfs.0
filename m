Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3E5017F4E
	for <xfs@oss.sgi.com>; Wed, 27 Nov 2013 20:20:36 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CD160AC003
	for <xfs@oss.sgi.com>; Wed, 27 Nov 2013 18:20:32 -0800 (PST)
Received: from mail-oa0-f53.google.com (mail-oa0-f53.google.com
	[209.85.219.53]) by cuda.sgi.com with ESMTP id ICp0uaZIvDfEIzOs
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 27 Nov 2013 18:20:31 -0800 (PST)
Received: by mail-oa0-f53.google.com with SMTP id m1so8419996oag.26
	for <xfs@oss.sgi.com>; Wed, 27 Nov 2013 18:20:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20131125134849.GC30189@infradead.org>
References: <1385379154-3802-1-git-send-email-zwu.kernel@gmail.com>
	<1385379154-3802-4-git-send-email-zwu.kernel@gmail.com>
	<20131125134849.GC30189@infradead.org>
Date: Thu, 28 Nov 2013 10:20:31 +0800
Message-ID: <CAEH94LgE+F5d1MrTJ8fhW1+NtJ2EjXbdngpqKbrnXwD2Gf=RCQ@mail.gmail.com>
Subject: Re: [RFC PATCH 3/4] xfs: add a new method xfs_vn_tmpfile()
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

On Mon, Nov 25, 2013 at 9:48 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Mon, Nov 25, 2013 at 07:32:33PM +0800, Zhi Yong Wu wrote:
>> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>>
>> Add a new O_TMPFILE method to VFS inteface.
>
> Looks reasonable except that you should pass on the parent inode.
ok, will do as this.
>



-- 
Regards,

Zhi Yong Wu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
