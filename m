Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6AD6D7F6C
	for <xfs@oss.sgi.com>; Tue, 28 Jul 2015 03:36:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 47E678F8065
	for <xfs@oss.sgi.com>; Tue, 28 Jul 2015 01:36:06 -0700 (PDT)
Received: from mail-wi0-f181.google.com (mail-wi0-f181.google.com
	[209.85.212.181]) by cuda.sgi.com with ESMTP id
	nrXp2oB7gaqPJKBE (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 28 Jul 2015 01:36:01 -0700 (PDT)
Received: by wibxm9 with SMTP id xm9so149604447wib.1
	for <xfs@oss.sgi.com>; Tue, 28 Jul 2015 01:36:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55B73365.1050908@mygrande.net>
References: <03864DDC681E664EBF5D47682BE7D7CF0D3574DF@USADCWVEMBX07.corp.global.level3.com>
	<55AA5FCE.4080702@sandeen.net>
	<03864DDC681E664EBF5D47682BE7D7CF0D358740@USADCWVEMBX07.corp.global.level3.com>
	<CAN3tLtJuk3LKHtxvbXATBR7bjr2e=GTX-fgs-jQniuxqRXjeoA@mail.gmail.com>
	<55AAF73A.4040903@mygrande.net>
	<20150720111747.GA53450@bfoster.bfoster>
	<55B73365.1050908@mygrande.net>
Date: Tue, 28 Jul 2015 10:35:59 +0200
Message-ID: <CAAxjCEyUa6vUTpgXLup0mXCTT6tHkGbQAu0TDE8kUhYfG8y8BA@mail.gmail.com>
Subject: Re: XFS File system in trouble
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
To: Leslie Rhorer <lrhorer@mygrande.net>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Tue, Jul 28, 2015 at 9:46 AM, Leslie Rhorer <lrhorer@mygrande.net> wrote:
>         The problem is this (from syslog):
> Jul 28 01:53:48 RAID-Server kernel: [431155.847523] loop: module loaded
> Jul 28 01:53:48 RAID-Server kernel: [431155.927238] XFS (loop0): Filesystem
> has duplicate UUID 228cfaa7-ae6b-44fc-b703-1c32385231c0 - can't mount
> Jul 28 01:55:51 RAID-Server kernel: [431278.916490] XFS (loop0): Filesystem
> has duplicate UUID 228cfaa7-ae6b-44fc-b703-1c32385231c0 - can't mount
>
>         Presumably it has the same UUID as the RAID array because it is
> expected to do so.  I can't mount it unless I umount the RAID array, but if
> I do that, I can't get to the file to mount the dump image, since it is on
> the array.

You can mount with -o nouuid, if are careful not to mount the same
physical storage twice.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
