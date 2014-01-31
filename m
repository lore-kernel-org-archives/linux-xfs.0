Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C15A67F63
	for <xfs@oss.sgi.com>; Fri, 31 Jan 2014 00:35:14 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id ACD628F8039
	for <xfs@oss.sgi.com>; Thu, 30 Jan 2014 22:35:11 -0800 (PST)
Received: from slmp-550-94.slc.westdc.net (slmp-550-94.slc.westdc.net
	[50.115.112.57]) by cuda.sgi.com with ESMTP id wqnc5LslFqg0A3fj
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 30 Jan 2014 22:35:10 -0800 (PST)
From: Chris Murphy <lists@colorremedies.com>
Subject: relationship of nested stripe sizes,
	was: Question regarding XFS on LVM over hardware RAID.
Date: Thu, 30 Jan 2014 23:35:08 -0700
Message-Id: <7A732267-B34F-4286-9B49-3AF8767C0B89@colorremedies.com>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
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
To: "stan@hardwarefreak.com Hoeppner" <stan@hardwarefreak.com>
Cc: xfs <xfs@oss.sgi.com>

Hopefully this is an acceptable way to avoid thread jacking, by renaming th=
e  subject=85

On Jan 30, 2014, at 10:58 PM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> =

> RAID60 is a nested RAID level just like RAID10 and RAID50.  It is a
> stripe, or RAID0, across multiple primary array types, RAID6 in this
> case.  The stripe width of each 'inner' RAID6 becomes the stripe unit of
> the 'outer' RAID0 array:
> =

> RAID6 geometry	 128KB * 12 =3D 1536KB
> RAID0 geometry  1536KB * 3  =3D 4608KB

My question is on this particular point. If this were hardware raid6, but I=
 wanted to then stripe using md raid0, using the numbers above would I choo=
se a raid0 chunk size of 1536KB? How critical is this value for, e.g. only =
large streaming read/write workloads? If it were smaller, say 256KB or even=
 32KB, would there be a significant performance consequence?

Chris Murphy
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
