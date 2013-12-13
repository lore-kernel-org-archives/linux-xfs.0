Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2B16429DF8
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 11:30:47 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1B0718F8064
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 09:30:38 -0800 (PST)
Received: from mail-ob0-f169.google.com (mail-ob0-f169.google.com
	[209.85.214.169]) by cuda.sgi.com with ESMTP id
	FNSs7vBH9FOdU2Tj (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 13 Dec 2013 09:30:07 -0800 (PST)
Received: by mail-ob0-f169.google.com with SMTP id wm4so2285046obc.28
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 09:29:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20131213163230.GE20803@infradead.org>
References: <1386944873-16796-1-git-send-email-zwu.kernel@gmail.com>
	<1386944873-16796-3-git-send-email-zwu.kernel@gmail.com>
	<20131213163230.GE20803@infradead.org>
Date: Sat, 14 Dec 2013 01:29:28 +0800
Message-ID: <CAEH94LhHnFjBif-uGS84EnFqXgoM1fGU+741CH_JSutJ43OWoA@mail.gmail.com>
Subject: Re: [PATCH 2/5] xfs: adjust the interface of xfs_qm_vop_dqalloc()
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
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>, linux-kernel mlist <linux-kernel@vger.kernel.org>, xfstests <xfs@oss.sgi.com>

On Sat, Dec 14, 2013 at 12:32 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, Dec 13, 2013 at 10:27:50PM +0800, Zhi Yong Wu wrote:
>> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>>
>> There may be not a parent inode or a name for O_TMPFILE support, but will pass
>> a struct xfs_mount to xfs_qm_vop_dqalloc(). So its interface need to be
>> adjusted in order that O_TMPFILE creation function can also use it.
>>
>> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>
> This patch is not actually needed, as we do get passed a parent.
Discarded, thanks.

>



-- 
Regards,

Zhi Yong Wu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
