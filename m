Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6642F7F37
	for <xfs@oss.sgi.com>; Mon, 10 Jun 2013 04:43:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 02D83AC002
	for <xfs@oss.sgi.com>; Mon, 10 Jun 2013 02:43:35 -0700 (PDT)
Received: from mail-we0-f178.google.com (mail-we0-f178.google.com
	[74.125.82.178]) by cuda.sgi.com with ESMTP id lb0sDRILQp4hObT2
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 10 Jun 2013 02:43:34 -0700 (PDT)
Received: by mail-we0-f178.google.com with SMTP id u53so4726963wes.9
	for <xfs@oss.sgi.com>; Mon, 10 Jun 2013 02:43:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51B45CFD.20500@hardwarefreak.com>
References: <51B45CFD.20500@hardwarefreak.com>
Date: Mon, 10 Jun 2013 11:43:32 +0200
Message-ID: <CAAxjCEznq0RDnnYR_mQ=gmSeson4acyiLVcVdOh2vmQo1cVAzA@mail.gmail.com>
Subject: Re: attack upon XFS, misinformation abounds, linux-raid list
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
To: stan@hardwarefreak.com
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Sun, Jun 9, 2013 at 12:46 PM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> In a recent linux-raid list thread here:
> http://marc.info/?l=linux-raid&m=137072140106867&w=2
>
> seriously flawed arguments against the reliability of XFS, and even the
> performance of XFS, are made.  The OP even quotes Dave's LCA
> presentation as a performance reason to avoid XFS.  The party really
> gets started at paragraph 7.
>
> I made a brief effort to debunk his claims and explained that he can't
> have O_PONIES, that he should use fsync or O_DIRECT, etc for data
> safety.  To non experts/advanced filesystem users, his long winded
> argument may be persuasive.  Obviously none of you experts has time to
> debunk every such post, but this one may be worth a read at least,
> especially given the weight Google gives to vger lists.

The really unfortunate thing about this is that the bug[1] which would
prevent transaction flushing from happening got imported and shipped
for a rather long time in RHEL. It's one thing to get a file zeroed
that's a few seconds old, but having the same happen to files which
haven't been touched in hours, even before issuing manual sync, is
certainly not very reassuring.

As a very satisfied user of XFS on CentOS 6, I have been nervous
enough about that to go through the trouble of rebooting our main
server for a kernel upgrade a few weeks ago. Thanks to RedHat's
deceptive tactics regarding kernel patches, I have also not been able
to pin-point the exact range of kernel versions affected by this in a
reasonable amount of time and hence have not found out (thankfully not
the hard way) if it was even necessary.

[1] https://access.redhat.com/site/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/6.4_Technical_Notes/kernel.html
"BZ#855139"

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
