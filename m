Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4B2C47F3F
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 11:30:18 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3A7CD304053
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 09:30:06 -0800 (PST)
Received: from mail-ob0-f180.google.com (mail-ob0-f180.google.com
	[209.85.214.180]) by cuda.sgi.com with ESMTP id
	a2RCoFv4AEh3RQLE (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 13 Dec 2013 09:29:58 -0800 (PST)
Received: by mail-ob0-f180.google.com with SMTP id wo20so2275060obc.11
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 09:29:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20131213163733.GF20803@infradead.org>
References: <1386944873-16796-1-git-send-email-zwu.kernel@gmail.com>
	<1386944873-16796-4-git-send-email-zwu.kernel@gmail.com>
	<20131213163733.GF20803@infradead.org>
Date: Sat, 14 Dec 2013 01:29:58 +0800
Message-ID: <CAEH94LhEvFff8rcfrbM1_xM4e=2H1083Jb194zYA6ERZcqDe+Q@mail.gmail.com>
Subject: Re: [PATCH 3/5] xfs: add xfs_create_tmpfile() for O_TMPFILE support
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

Fixed them, thanks.

On Sat, Dec 14, 2013 at 12:37 AM, Christoph Hellwig <hch@infradead.org> wrote:
>> +     error = xfs_dir_ialloc(&tp, NULL, mode, 0, rdev,
>
> please pass the parent inode pointer here.
>
>> +                             XFS_PROJID_DEFAULT, resblks > 0,
>
> and pass the project id that you inherited from the parent here.
>



-- 
Regards,

Zhi Yong Wu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
