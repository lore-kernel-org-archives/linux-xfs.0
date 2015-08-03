Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8678D7F59
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 12:27:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 72E9A8F8035
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 10:27:09 -0700 (PDT)
Received: from mail-wi0-f172.google.com (mail-wi0-f172.google.com
	[209.85.212.172]) by cuda.sgi.com with ESMTP id
	n6Fe79kOJbmXIH7Q (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 03 Aug 2015 10:27:08 -0700 (PDT)
Received: by wibud3 with SMTP id ud3so145069760wib.1
	for <xfs@oss.sgi.com>; Mon, 03 Aug 2015 10:27:07 -0700 (PDT)
Received: from [192.168.1.171] (50-197-102-113-static.hfc.comcastbusiness.net.
	[50.197.102.113]) by smtp.googlemail.com with ESMTPSA id
	r6sm14582236wiy.13.2015.08.03.10.27.04 for <xfs@oss.sgi.com>
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Mon, 03 Aug 2015 10:27:05 -0700 (PDT)
From: Joe Landman <joe.landman@gmail.com>
Subject: swalloc/allocsize question
Message-ID: <55BFA467.8000707@gmail.com>
Date: Mon, 3 Aug 2015 13:27:03 -0400
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi folks:

   I've noticed some "odd" behavior while experimenting with xfs mounts 
on relatively recent kernels (3.18 series).  Basically, the 
swalloc,allocsize=x options are being modified to something different.  
That is:

root@usn-04:~/burn-in/fio# uname -r
3.18.12.scalable

root@usn-04:~/burn-in/fio# mount -o 
inode64,noatime,nodiratime,swalloc,allocsize=1280k /dev/sda /data/1

root@usn-04:~/burn-in/fio# mount | grep sda
/dev/sda on /data/1 type xfs 
(rw,noatime,nodiratime,swalloc,attr2,inode64,allocsize=256k,noquota)

This is a hardware RAID6 with a 128k chunk size and 12 elements (so 10 
data drives, thus the 1280k allocsize for stripe width allocation).  Is 
this something specific to xfs itself, or is this an issue in the mount 
tools ?

FWIW: we are using xfs-tools 3.2.2, kernel 3.18.12.  I've also seen this 
with the 3.10 series though, so I am not sure where to look to track 
this down.  Any guidance/suggestion?  Thanks!

Joe

joe.landman@gmail.com


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
