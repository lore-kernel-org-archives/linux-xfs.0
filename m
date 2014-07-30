Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AD2CE7F47
	for <xfs@oss.sgi.com>; Wed, 30 Jul 2014 07:30:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8C356304051
	for <xfs@oss.sgi.com>; Wed, 30 Jul 2014 05:30:22 -0700 (PDT)
Received: from mail-qg0-f43.google.com (mail-qg0-f43.google.com
	[209.85.192.43]) by cuda.sgi.com with ESMTP id 44uzrpkAqL8fZzm1
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 30 Jul 2014 05:30:12 -0700 (PDT)
Received: by mail-qg0-f43.google.com with SMTP id a108so1287947qge.2
	for <xfs@oss.sgi.com>; Wed, 30 Jul 2014 05:30:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1406684929-11133-5-git-send-email-david@fromorbit.com>
References: <1406684929-11133-1-git-send-email-david@fromorbit.com>
	<1406684929-11133-5-git-send-email-david@fromorbit.com>
Date: Wed, 30 Jul 2014 14:30:11 +0200
Message-ID: <CA+o=1OWqWXXLGLB9-TgkmBUDfFs0GpmQS=4to3tO6-R0FvgLuA@mail.gmail.com>
Subject: Re: [PATCH 4/4] xfs: dquot recovery needs verifiers
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

2014-07-30 3:48 GMT+02:00 Dave Chinner <david@fromorbit.com>:
> +       if (!mp->m_qflags == 0)
> +               return false;

Is it a typo, or is it intentionally obfuscated mp->m_qflags != 0?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
