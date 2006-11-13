Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 13 Nov 2006 08:35:42 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kADGZWaG029179
	for <xfs@oss.sgi.com>; Mon, 13 Nov 2006 08:35:33 -0800
Received: from houinet7.hou.moc.com (houinet7.hou.moc.com [192.70.218.25])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9648A51B210
	for <xfs@oss.sgi.com>; Mon, 13 Nov 2006 08:10:15 -0800 (PST)
Subject: RHEL 4 Compatible Kernel Module Code
From: "Stephen C. Rigler" <srigler@marathonoil.com>
Content-Type: multipart/mixed; boundary="=-8t7RM/+IJRZy4HtfBske"
Date: Mon, 13 Nov 2006 10:10:10 -0600
Message-Id: <1163434210.25484.14.camel@houuc8>
Mime-Version: 1.0
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

--=-8t7RM/+IJRZy4HtfBske
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Greetings,

We are using CentOS 4.4 along with the RHEL 4 compatible kernel modules
(downloadable here:
http://mirror.centos.org/centos/4.4/centosplus/x86_64/RPMS/).

According to the CentOS mailing list, the person at SGI who had been
backporting the xfs code for RHEL4/CentOS4 has left the company.

Are there any plans to continue this work?  It seems like we are getting
bit by this bug: http://oss.sgi.com/bugzilla/show_bug.cgi?id=410 but it
doesn't look like the fix has been backported to the RHEL4 kernel
module.

Thanks,
Steve

--=-8t7RM/+IJRZy4HtfBske
Content-Disposition: inline
Content-Description: Forwarded message - Re: [CentOS] Re: XFS Issues
Content-Type: message/rfc822

Received: from pnors230.mgroupnet.com ([89.32.18.248]) by
	pnors220.mgroupnet.com with Microsoft SMTPSVC(6.0.3790.1830); Wed, 8 Nov
	2006 16:47:32 -0600
Received: from fdyinet2.fin.moc.com ([89.2.42.65]) by
	pnors230.mgroupnet.com with Microsoft SMTPSVC(6.0.3790.1830); Wed, 8 Nov
	2006 16:47:32 -0600
Received: from fdyinet2 ([65.219.124.100]) by fdyinet2.fin.moc.com with
	Microsoft SMTPSVC(6.0.3790.1830); Wed, 8 Nov 2006 17:47:29 -0500
Received: from plmler1.mail.eds.com (localhost [127.0.0.1]) by
	plmler1.mail.eds.com (8.13.8/8.12.10) with ESMTP id kA8Mkar7019397 for
	<srigler@marathonoil.com>; Wed, 8 Nov 2006 16:46:36 -0600
Received: from plmler1.mail.eds.com (localhost [127.0.0.1]) by
	plmler1.mail.eds.com (8.13.8/8.12.10) with ESMTP id kA8Mj85J014819 for
	<srigler@marathonoil.com>; Wed, 8 Nov 2006 16:45:08 -0600
Received: from mail.centos.org (mail.centos.org [72.21.40.12]) by
	plmler1.mail.eds.com (8.13.8/8.12.10) with ESMTP id kA8Mj88A014803 for
	<srigler@marathonoil.com>; Wed, 8 Nov 2006 16:45:08 -0600
X-EDS-Source-Ip: 72.21.40.12
X-EDS-Source-Name: mail.centos.org
X-EDS-Reported-Name: mail.centos.org
Received: from lists.centos.org (localhost.localdomain [127.0.0.1]) by
	mail.centos.org (Postfix) with ESMTP id E317BF3C443; Wed,  8 Nov 2006
	22:44:54 +0000 (UTC)
X-Original-To: centos@centos.org
Delivered-To: centos@centos.org
Received: from nf-out-0910.google.com (nf-out-0910.google.com
	[64.233.182.184]) by mail.centos.org (Postfix) with ESMTP id B5D88F3C244
	for <centos@centos.org>; Wed,  8 Nov 2006 22:44:50 +0000 (UTC)
Received: by nf-out-0910.google.com with SMTP id n15so478150nfc for
	<centos@centos.org>; Wed, 08 Nov 2006 14:44:50 -0800 (PST)
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=beta; d=gmail.com;
	h=received:message-id:date:from:sender:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
	b=Buu9Y3hRHhSe95zJw4sSTb3NpnVxBW/TY5VvHIluGSfodvFXuFCNV35rFHfgZV26jj9uBIAt2YnJifxqM7wSSHOwKCA5lUR3v5+TCThxPM5nA9pHB4V851BKIWMxBfYCzCSpzenaeRDuktyORajmEAzKGRvHbvUazbFZaJz3SPs=
Received: by 10.49.3.10 with SMTP id f10mr2964749nfi.1163025889883; Wed, 08
	Nov 2006 14:44:49 -0800 (PST)
Received: by 10.48.212.2 with HTTP; Wed, 8 Nov 2006 14:44:49 -0800 (PST)
Message-ID: <a92ebfd90611081444y26b23c24yb13d1b20d22ce2d4@mail.gmail.com>
Date: Wed, 8 Nov 2006 22:44:49 +0000
From: "James Pearson" <james-p@moving-picture.com>
To: "CentOS mailing list" <centos@centos.org>
Subject: Re: [CentOS] Re: XFS Issues
In-Reply-To: <1163013603.25393.23.camel@houuc8>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1163006260.25393.10.camel@houuc8> <eit9rb$u3d$1@sea.gmane.org>
	 <1163013603.25393.23.camel@houuc8>
X-Google-Sender-Auth: f30592bec6a19f7f
X-BeenThere: centos@centos.org
X-Mailman-Version: 2.1.5
Precedence: list
Reply-To: CentOS mailing list <centos@centos.org>
List-Id: CentOS mailing list <centos.centos.org>
List-Unsubscribe: <http://lists.centos.org/mailman/listinfo/centos>,
	<mailto:centos-request@centos.org?subject=unsubscribe>
List-Archive: <http://lists.centos.org/pipermail/centos>
List-Post: <mailto:centos@centos.org>
List-Help: <mailto:centos-request@centos.org?subject=help>
List-Subscribe: <http://lists.centos.org/mailman/listinfo/centos>,
	<mailto:centos-request@centos.org?subject=subscribe>
Sender: centos-bounces@centos.org
Errors-To: centos-bounces@centos.org
X-Brightmail-Flag: NO
X-Spam-Flag: NO
X-Spam-Checker-Version: SpamAssassin 2.64 (2004-01-11) on
	plmler1.mail.eds.com
X-Spam-Report: This mail has been scanned in order to control spam. The
	results are given below in the "Content Analysis" line. If the number of
	points is greater than required, then this mail is very probably spam.
	---------------- Content Analysis:   (0.0 points, 5.0 required)
	----------------
X-Spam-Status: No, hits=0.0 required=5.0 tests=none
X-Spam-Level: 
X-Envelope-Trace: plmler1.kA8Mj85J014819
X-Envelope-From: <centos-bounces@centos.org>
Return-Path: centos-bounces@centos.org
X-OriginalArrivalTime: 08 Nov 2006 22:47:29.0293 (UTC)
	FILETIME=[DE920BD0:01C70387]

On 08/11/06, Stephen C. Rigler <srigler@marathonoil.com> wrote:
> On Wed, 2006-11-08 at 11:06 -0800, Scott Silva wrote:
> > > Is there any chance that the fix will make it into the centosplus
> > > kernel-module-xfs?
> > Why not try installing 2.6.9-42.0.3 and see if maybe it is fixed?
> >
>
> I installed it on a different system and the modinfo for xfs still gives
> the same information:
>
> description:    SGI-XFS CVS-2004-10-17_05:00_UTC
>
> Has the module been updated since 2.6.9-34.0.1?

The kernel-module-xfs code hasn't changed in a while - that date stamp
is incorrect, but the code is more like a year old.

Unfortunately, the person at SGI that packaged up the code in the XFS
module for RHEL4/CentOS4 no longer works for SGI (I believe he now
works for RedHat).

So, I guess, unless someone else at SGI (or elsewhere) back ports the
more recent XFS code to the RHEL4 kernel, you are out of luck ...

Or you could use an up to date kernel.org kernel instead ...

James Pearson
_______________________________________________
CentOS mailing list
CentOS@centos.org
http://lists.centos.org/mailman/listinfo/centos


--=-8t7RM/+IJRZy4HtfBske--
