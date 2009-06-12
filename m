Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5C5R9hc190177 for <xfs@oss.sgi.com>; Fri, 12 Jun 2009 00:27:09 -0500
Received: from mail-px0-f194.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 272431AC0A8D
	for <xfs@oss.sgi.com>; Thu, 11 Jun 2009 22:27:30 -0700 (PDT)
Received: from mail-px0-f194.google.com (mail-px0-f194.google.com
	[209.85.216.194]) by cuda.sgi.com with ESMTP id
	jtS5G05FbEG08Lce for <xfs@oss.sgi.com>;
	Thu, 11 Jun 2009 22:27:30 -0700 (PDT)
Received: by pxi32 with SMTP id 32so1452944pxi.20
	for <xfs@oss.sgi.com>; Thu, 11 Jun 2009 22:27:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A31E0FF.8050400@tlinx.org>
References: <4A31E0FF.8050400@tlinx.org>
Date: Fri, 12 Jun 2009 10:57:30 +0530
Message-ID: <921ca19c0906112227m2c834808jd62b15d0203fe4e3@mail.gmail.com>
Subject: Re: grub no longer being maintained? drops support for XFS?
From: Sujit Karataparambil <sjt.kar@gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "Linda A. Walsh" <suse@tlinx.org>
Cc: SuSE Linux <opensuse@opensuse.org>, xfs-oss <xfs@oss.sgi.com>

This is an Known Issue. Grub hangs when used With XFS. You could
Try Lilo instead. But does the same with my experiance.

On Fri, Jun 12, 2009 at 10:30 AM, Linda A. Walsh<suse@tlinx.org> wrote:
> I just saw this bug, https://bugzilla.novell.com/show_bug.cgi?id=459792,
> that reports a problem in OpenSUSE with Grub being unable to boot with
> XFS when someone upgraded from OpenSuSE11.0 to OpenSuSE11.1.
> Quote:
>
> Grub is unable to start if /boot is on xfs partition.
> Found after updating from 11.0 to 11.1.
>
> Response from Novell:
>
> ------- Comment #1 From Jiri Srain (jsrain(at)novell(dot)com) 2008-12-18
> 04:24:39 MST -------
>
> We agreed with product management that /boot on XFS will not be a supported
> bootloader scenario. See relevant thread on factory to see explanations;
> successful booting from XFS is just a pure luck.
>
> Perhaps if Grub can't support XFS, the default bootloader should
> be upgraded to 'lilo' -- as it still seems to be maintained and still
> supports high performance file systems like XFS.
>
>
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>



-- 
-- Sujit K M

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
