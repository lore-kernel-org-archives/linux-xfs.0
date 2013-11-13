Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A2FB17F3F
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 15:43:25 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 84AC0304039
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 13:43:25 -0800 (PST)
Received: from mail-wi0-f175.google.com (mail-wi0-f175.google.com
	[209.85.212.175]) by cuda.sgi.com with ESMTP id
	sUv29mXIsqEk6zPr (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 13 Nov 2013 13:43:24 -0800 (PST)
Received: by mail-wi0-f175.google.com with SMTP id hm11so5945389wib.8
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 13:43:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5283E387.70704@gmail.com>
References: <2662179.4mj0dgORXu@r008>
	<5283E387.70704@gmail.com>
Date: Wed, 13 Nov 2013 22:43:23 +0100
Message-ID: <CAAxjCEz5ncQGfpZTfeps1r+U0q8E26P5_t6Mk_QP4FekvbRivA@mail.gmail.com>
Subject: Re: Files not touched in weeks got truncated after a crash
From: Stefan Ring <stefanrin@gmail.com>
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
To: Linux fs XFS <xfs@oss.sgi.com>
Cc: Guido Winkelmann <guido@ambient-entertainment.de>

On Wed, Nov 13, 2013 at 9:39 PM, Ric Wheeler <ricwheeler@gmail.com> wrote:
> You should update your kernel - this sounds like an issue that Dave fixed
> quite a few months back (and got shipped in RHEL and other distros, I don't
> know about when Centos would pick it up)

It's in the CentOS 6.4 kernel, according to the release notes:
https://access.redhat.com/site/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/6.4_Technical_Notes/kernel.html
(BZ#855139)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
