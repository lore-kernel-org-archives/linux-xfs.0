Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2D5A57F5E
	for <xfs@oss.sgi.com>; Tue, 11 Nov 2014 12:00:33 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1C01A304048
	for <xfs@oss.sgi.com>; Tue, 11 Nov 2014 10:00:29 -0800 (PST)
Received: from slmp-550-94.slc.westdc.net (slmp-550-94.slc.westdc.net
	[50.115.112.57]) by cuda.sgi.com with ESMTP id 5Ekh0a3vDauAjT6N
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 11 Nov 2014 10:00:28 -0800 (PST)
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: Enforcing quota for root user
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <54622CE8.7050508@hardwarefreak.com>
Date: Tue, 11 Nov 2014 11:00:25 -0700
Message-Id: <631A9090-F9FE-4B8E-88CD-1B30CAFC65B7@colorremedies.com>
References: <67EDE14C-CCFB-4B42-8B78-FC6C813CD19A@free.fr>	<5461B333.8050609@hardwarefreak.com>
	<F7ACFF71-460D-40E7-999C-BFC8D232EA81@free.fr>
	<54622CE8.7050508@hardwarefreak.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Stan Hoeppner <stan@hardwarefreak.com>, xfs@oss.sgi.com


On Nov 11, 2014, at 8:36 AM, Stan Hoeppner <stan@hardwarefreak.com> wrote:

> On 11/11/2014 04:22 AM, Cyril Scetbon wrote:
>> That's what I've read first, but someone showed me a sample where it wor=
ks. He just told me he was using project quota. However, does it make sense=
 ? =

>> I've also read somewhere else that quota is never enforced for root user=
 (id,gid=3D0) that's why I was testing it ....
> =

> No, it doesn't make sense.  Why would you want to enforce quotas for root?

A week ago I tried this and project quotas appear to apply to root.

[root@localhost project_quota_test1]# xfs_quota -c df
Filesystem           1K-blocks       Used  Available  Use% Pathname
/dev/sdb              83845120     157980   83687140    0% /xfs_local
/dev/sdb                102400     124928 9223372036854753280  122% /xfs_lo=
cal/project_quota_test1
[root@localhost project_quota_test1]# dd if=3D/dev/zero of=3Dtest100MB bs=
=3D1M count=3D100
dd: error writing =91test100MB=92: No space left on device
79+0 records in
78+0 records out
81788928 bytes (82 MB) copied, 0.163849 s, 499 MB/s
[root@localhost project_quota_test1]# xfs_quota -c df
Filesystem           1K-blocks       Used  Available  Use% Pathname
/dev/sdb              83845120     237748   83607372    0% /xfs_local
/dev/sdb                102400     204800 9223372036854673408  200% /xfs_lo=
cal/project_quota_test1


The available space value seems like a bug, at least it=92s not a sane/help=
ful value. But I do get a no space left on device, and the file being writt=
en is truncated at the hard limit for that project (directory).


Chris Murphy
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
