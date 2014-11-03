Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 466EA7F5A
	for <xfs@oss.sgi.com>; Mon,  3 Nov 2014 16:12:18 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C875DAC005
	for <xfs@oss.sgi.com>; Mon,  3 Nov 2014 14:12:17 -0800 (PST)
Received: from mail-ob0-f175.google.com (mail-ob0-f175.google.com
	[209.85.214.175]) by cuda.sgi.com with ESMTP id
	imJcaNxho3acJu30 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 03 Nov 2014 14:12:13 -0800 (PST)
Received: by mail-ob0-f175.google.com with SMTP id gq1so4904937obb.34
	for <xfs@oss.sgi.com>; Mon, 03 Nov 2014 14:12:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1415031146-9107-6-git-send-email-bfoster@redhat.com>
References: <1415031146-9107-1-git-send-email-bfoster@redhat.com>
	<1415031146-9107-6-git-send-email-bfoster@redhat.com>
Date: Mon, 3 Nov 2014 23:12:12 +0100
Message-ID: <CA+o=1OWm3XWUgNXR1_CravnEBL8fD8dwyMvY4CN9rbAsw0Q4Sw@mail.gmail.com>
Subject: Re: [PATCH v2 05/17] xfs: create macros/helpers for dealing with
	sparse inode chunks
From: Fanael Linithien <fanael4@gmail.com>
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
Cc: xfs@oss.sgi.com

2014-11-03 17:12 GMT+01:00 Brian Foster <bfoster@redhat.com>:
>
> +static inline bool xfs_inobt_issparse(uint16_t holemask)
> +{
> +       return holemask == 0 ? false : true;
> +}

Surely that should be "return holemask != 0;"?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
