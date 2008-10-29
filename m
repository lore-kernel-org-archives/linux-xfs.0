Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 29 Oct 2008 09:02:15 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9TG21tf030247
	for <linux-xfs@oss.sgi.com>; Wed, 29 Oct 2008 09:02:02 -0700
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6CE9A559841
	for <linux-xfs@oss.sgi.com>; Wed, 29 Oct 2008 09:02:01 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31]) by cuda.sgi.com with ESMTP id MjRXL2xsD4RlIepX for <linux-xfs@oss.sgi.com>; Wed, 29 Oct 2008 09:02:01 -0700 (PDT)
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m9TG20re021512
	for <linux-xfs@oss.sgi.com>; Wed, 29 Oct 2008 12:02:00 -0400
Received: from pobox.stuttgart.redhat.com (pobox.stuttgart.redhat.com [172.16.2.10])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9TG1wi9013780
	for <linux-xfs@oss.sgi.com>; Wed, 29 Oct 2008 12:01:59 -0400
Received: from dhcp-lab-218.englab.brq.redhat.com (dhcp-lab-225.englab.brq.redhat.com [10.34.33.225])
	by pobox.stuttgart.redhat.com (8.13.1/8.13.1) with ESMTP id m9TG1wQq005984
	for <linux-xfs@oss.sgi.com>; Wed, 29 Oct 2008 12:01:58 -0400
Message-ID: <490888F6.8000101@redhat.com>
Date: Wed, 29 Oct 2008 17:01:58 +0100
From: Zdenek Prikryl <zprikryl@redhat.com>
MIME-Version: 1.0
Subject: getfattr and -d options
Content-Type: multipart/mixed;
 boundary="------------030807070105090905020207"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------030807070105090905020207
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hello,
in getfattr's man page there is "-d Dump the values of all extended attributes
associated with path-name". If you use SELinux, files have this extended attribute:

security.selinux="...".

-d option works in such way that it only prints extended attributes, which names
begin with "user." So, in this case, selinux attribute isn't printed. I'm
sending simple patch, which corrects this.

Best regards.

-- 
Zdenek Prikryl <zprikryl@redhat.com>


--------------030807070105090905020207
Content-Type: text/plain;
 name="attr-2.4.43-dump.patch"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="attr-2.4.43-dump.patch"

ZGlmZiAtdXAgYXR0ci0yLjQuNDMvZ2V0ZmF0dHIvZ2V0ZmF0dHIuYy5kdW1w
IGF0dHItMi40LjQzL2dldGZhdHRyL2dldGZhdHRyLmMKLS0tIGF0dHItMi40
LjQzL2dldGZhdHRyL2dldGZhdHRyLmMuZHVtcAkyMDA4LTEwLTI5IDE2OjU1
OjQzLjAwMDAwMDAwMCArMDEwMAorKysgYXR0ci0yLjQuNDMvZ2V0ZmF0dHIv
Z2V0ZmF0dHIuYwkyMDA4LTEwLTI5IDE2OjU1OjQ1LjAwMDAwMDAwMCArMDEw
MApAQCAtNDA4LDYgKzQwOCw3IEBAIGludCBtYWluKGludCBhcmdjLCBjaGFy
ICphcmd2W10pCiAKIAkJCWNhc2UgJ2QnOiAvKiBkdW1wIGF0dHJpYnV0ZSB2
YWx1ZXMgKi8KIAkJCQlvcHRfZHVtcCA9IDE7CisJCQkJb3B0X25hbWVfcGF0
dGVybiA9ICIiOwogCQkJCWJyZWFrOwogCiAJCQljYXNlICdlJzogIC8qIGVu
Y29kaW5nICovCg==

--------------030807070105090905020207--
