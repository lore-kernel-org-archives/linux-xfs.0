Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 05 Jan 2007 14:33:07 -0800 (PST)
Received: from service.eng.exegy.net (68-191-203-42.static.stls.mo.charter.com [68.191.203.42])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l05MWxqw011921
	for <linux-xfs@oss.sgi.com>; Fri, 5 Jan 2007 14:33:00 -0800
Received: from HANAFORD.eng.exegy.net (hanaford.eng.exegy.net [10.19.1.4])
	by service.eng.exegy.net (8.13.1/8.13.1) with ESMTP id l05MJnIS010019
	for <linux-xfs@oss.sgi.com>; Fri, 5 Jan 2007 16:19:49 -0600
Message-ID: <459ECF04.4090803@exegy.com>
Date: Fri, 05 Jan 2007 16:19:48 -0600
From: Dave Lloyd <dlloyd@exegy.com>
MIME-Version: 1.0
Subject: [Fwd: [Fwd: xfs write speed regression 2.6.18.1 to 	
	2.6.19.1]]
Content-Type: multipart/mixed;
	 boundary="------------060803090605060507010505"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------060803090605060507010505
Content-Type: text/plain; charset="ISO-8859-1"; format="flowed"
Content-Transfer-Encoding: 7bit

 From a co-worker. Anyone know what might have changed this between
2.6.18 and 2.6.19 when the issue first appeared?

-- 
Dave Lloyd
Product Support Engineer, Exegy, Inc.
+1.314.450.5342
dlloyd@exegy.com

-------- Original Message --------
Subject: [Fwd: xfs write speed regression 2.6.18.1 to 	2.6.19.1]
Date: Fri, 05 Jan 2007 16:16:11 -0600
From: Mr. Berkley Shands <bshands@exegy.com>
To: Dave Lloyd <dlloyd@exegy.com>

The short summary is under 2.6.18.* xfs is able to maintain a write rate
of > 900MB/Sec for the first TB of data. Peak is ~256MB/Sec per raid X 4
raids.
Under 2.6.19.1 this rate drops to ~220MB/Sec. and the allocations are no
longer smooth
starting at the outside edges.

under 2.6.20-rc3 the speeds have gone back up some, but they are 10%
slower than 2.6.18.
and the allocations, as shown by the sequential writes (attached) are
random.
If I went all the way out to the inside tracks, you would be at about
490MB/Sec.

Something changed. 2.6.19 was unstable, with XFS panics on a regular basis.
2.6.19.1 has not had an error yet.. (knock head on wall repeatedly).

berkley

-- 

//E. F. Berkley Shands, MSc//

**Exegy Inc.**

3668 S. Geyer Road, Suite 300

St. Louis, MO  63127

Direct:  (314) 450-5348

Cell:  (314) 303-2546

Office:  (314) 450-5353

Fax:  (314) 450-5354



This e-mail and any documents accompanying it may contain legally
privileged and/or confidential information belonging to Exegy, Inc.
Such information may be protected from disclosure by law.  The
information is intended for use by only the addressee.  If you are not
the intended recipient, you are hereby notified that any disclosure or
use of the information is strictly prohibited.  If you have received
this e-mail in error, please immediately contact the sender by e-mail or
phone regarding instructions for return or destruction and do not use or
disclose the content to others.






--------------060803090605060507010505
Content-Type: text/plain; name="2.6.20-rc3run.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="2.6.20-rc3run.txt"

Data: Writing, 8192 MB, Buffer: 128 KB, Time: 58322 MS, Rate:   140.462, to /s2/GigaData.0
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 58321 MS, Rate:   140.464, to /s0/GigaData.0
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 58325 MS, Rate:   140.454, to /s1/GigaData.0
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 58356 MS, Rate:   140.380, to /s3/GigaData.0
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 43031 MS, Rate:   190.374, to /s2/GigaData.1
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 43043 MS, Rate:   190.321, to /s3/GigaData.1
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 44439 MS, Rate:   184.343, to /s1/GigaData.1
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 44439 MS, Rate:   184.343, to /s0/GigaData.1
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 38326 MS, Rate:   213.745, to /s0/GigaData.2
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 47993 MS, Rate:   170.692, to /s3/GigaData.2
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 47999 MS, Rate:   170.670, to /s1/GigaData.2
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 47998 MS, Rate:   170.674, to /s2/GigaData.2
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 46339 MS, Rate:   176.784, to /s1/GigaData.3
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 46337 MS, Rate:   176.792, to /s2/GigaData.3
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 46333 MS, Rate:   176.807, to /s3/GigaData.3
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 46369 MS, Rate:   176.670, to /s0/GigaData.3
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 44952 MS, Rate:   182.239, to /s1/GigaData.4
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 44952 MS, Rate:   182.239, to /s0/GigaData.4
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 44952 MS, Rate:   182.239, to /s3/GigaData.4
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 44951 MS, Rate:   182.243, to /s2/GigaData.4
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 41365 MS, Rate:   198.042, to /s2/GigaData.5
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 41357 MS, Rate:   198.080, to /s3/GigaData.5
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 41365 MS, Rate:   198.042, to /s0/GigaData.5
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 41365 MS, Rate:   198.042, to /s1/GigaData.5
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 38159 MS, Rate:   214.681, to /s1/GigaData.6
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 38168 MS, Rate:   214.630, to /s0/GigaData.6
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 39051 MS, Rate:   209.777, to /s3/GigaData.6
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 39055 MS, Rate:   209.755, to /s2/GigaData.6
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 37189 MS, Rate:   220.280, to /s2/GigaData.7
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 37189 MS, Rate:   220.280, to /s0/GigaData.7
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 37190 MS, Rate:   220.274, to /s1/GigaData.7
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 37189 MS, Rate:   220.280, to /s3/GigaData.7
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 34397 MS, Rate:   238.160, to /s3/GigaData.8
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 34876 MS, Rate:   234.889, to /s0/GigaData.8
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 34870 MS, Rate:   234.930, to /s1/GigaData.8
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 34880 MS, Rate:   234.862, to /s2/GigaData.8
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 36910 MS, Rate:   221.945, to /s0/GigaData.9
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 36896 MS, Rate:   222.029, to /s1/GigaData.9
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 36909 MS, Rate:   221.951, to /s3/GigaData.9
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 36930 MS, Rate:   221.825, to /s2/GigaData.9
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 38086 MS, Rate:   215.092, to /s3/GigaData.10
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 38082 MS, Rate:   215.115, to /s1/GigaData.10
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 38079 MS, Rate:   215.132, to /s2/GigaData.10
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 38118 MS, Rate:   214.912, to /s0/GigaData.10
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 45715 MS, Rate:   179.197, to /s0/GigaData.11
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 45714 MS, Rate:   179.201, to /s3/GigaData.11
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 45709 MS, Rate:   179.221, to /s1/GigaData.11
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 45745 MS, Rate:   179.080, to /s2/GigaData.11
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 37772 MS, Rate:   216.880, to /s2/GigaData.12
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 37772 MS, Rate:   216.880, to /s0/GigaData.12
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 37957 MS, Rate:   215.823, to /s3/GigaData.12
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 37966 MS, Rate:   215.772, to /s1/GigaData.12
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 34264 MS, Rate:   239.085, to /s1/GigaData.13
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 39469 MS, Rate:   207.555, to /s0/GigaData.13
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 39469 MS, Rate:   207.555, to /s3/GigaData.13
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 39469 MS, Rate:   207.555, to /s2/GigaData.13
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 36136 MS, Rate:   226.699, to /s2/GigaData.14
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 36137 MS, Rate:   226.693, to /s0/GigaData.14
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 35995 MS, Rate:   227.587, to /s3/GigaData.14
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 36174 MS, Rate:   226.461, to /s1/GigaData.14
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 35942 MS, Rate:   227.923, to /s2/GigaData.15
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 38528 MS, Rate:   212.625, to /s0/GigaData.15
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 38529 MS, Rate:   212.619, to /s1/GigaData.15
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 38529 MS, Rate:   212.619, to /s3/GigaData.15
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 35233 MS, Rate:   232.509, to /s1/GigaData.16
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 39777 MS, Rate:   205.948, to /s0/GigaData.16
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 39784 MS, Rate:   205.912, to /s2/GigaData.16
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 39778 MS, Rate:   205.943, to /s3/GigaData.16
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 41775 MS, Rate:   196.098, to /s3/GigaData.17
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 41767 MS, Rate:   196.136, to /s1/GigaData.17
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 41775 MS, Rate:   196.098, to /s0/GigaData.17
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 41803 MS, Rate:   195.967, to /s2/GigaData.17
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 39528 MS, Rate:   207.245, to /s0/GigaData.18
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 39529 MS, Rate:   207.240, to /s1/GigaData.18
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 39529 MS, Rate:   207.240, to /s3/GigaData.18
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 39561 MS, Rate:   207.073, to /s2/GigaData.18
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 37776 MS, Rate:   216.857, to /s2/GigaData.19
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 37779 MS, Rate:   216.840, to /s1/GigaData.19
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 37805 MS, Rate:   216.691, to /s3/GigaData.19
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 37806 MS, Rate:   216.685, to /s0/GigaData.19
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 38755 MS, Rate:   211.379, to /s1/GigaData.20
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 48546 MS, Rate:   168.747, to /s3/GigaData.20
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 48544 MS, Rate:   168.754, to /s0/GigaData.20
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 48536 MS, Rate:   168.782, to /s2/GigaData.20
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 41471 MS, Rate:   197.536, to /s2/GigaData.21
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 41476 MS, Rate:   197.512, to /s3/GigaData.21
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 52133 MS, Rate:   157.137, to /s1/GigaData.21
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 52135 MS, Rate:   157.131, to /s0/GigaData.21
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 49764 MS, Rate:   164.617, to /s1/GigaData.22
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 49757 MS, Rate:   164.640, to /s3/GigaData.22
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 49761 MS, Rate:   164.627, to /s2/GigaData.22
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 49764 MS, Rate:   164.617, to /s0/GigaData.22
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 39496 MS, Rate:   207.413, to /s2/GigaData.23
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 39491 MS, Rate:   207.440, to /s1/GigaData.23
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 39493 MS, Rate:   207.429, to /s3/GigaData.23
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 39490 MS, Rate:   207.445, to /s0/GigaData.23
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 41942 MS, Rate:   195.317, to /s3/GigaData.24
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 41942 MS, Rate:   195.317, to /s0/GigaData.24
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 41977 MS, Rate:   195.154, to /s1/GigaData.24
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 41983 MS, Rate:   195.127, to /s2/GigaData.24
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 38669 MS, Rate:   211.849, to /s3/GigaData.25
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 38672 MS, Rate:   211.833, to /s2/GigaData.25
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 39293 MS, Rate:   208.485, to /s0/GigaData.25
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 39292 MS, Rate:   208.490, to /s1/GigaData.25
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 39109 MS, Rate:   209.466, to /s2/GigaData.26
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 40761 MS, Rate:   200.976, to /s3/GigaData.26
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 40765 MS, Rate:   200.957, to /s1/GigaData.26
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 40766 MS, Rate:   200.952, to /s0/GigaData.26
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 39390 MS, Rate:   207.972, to /s2/GigaData.27
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 39397 MS, Rate:   207.935, to /s3/GigaData.27
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 39393 MS, Rate:   207.956, to /s0/GigaData.27
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 39392 MS, Rate:   207.961, to /s1/GigaData.27
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 51472 MS, Rate:   159.154, to /s2/GigaData.28
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 51471 MS, Rate:   159.158, to /s3/GigaData.28
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 51474 MS, Rate:   159.148, to /s0/GigaData.28
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 51473 MS, Rate:   159.151, to /s1/GigaData.28
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 46326 MS, Rate:   176.834, to /s3/GigaData.29
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 46327 MS, Rate:   176.830, to /s2/GigaData.29
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 46329 MS, Rate:   176.822, to /s1/GigaData.29
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 46330 MS, Rate:   176.818, to /s0/GigaData.29
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 38183 MS, Rate:   214.546, to /s3/GigaData.30
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 38183 MS, Rate:   214.546, to /s2/GigaData.30
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 38812 MS, Rate:   211.069, to /s0/GigaData.30
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 38813 MS, Rate:   211.063, to /s1/GigaData.30
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 37634 MS, Rate:   217.676, to /s0/GigaData.31
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 37564 MS, Rate:   218.081, to /s2/GigaData.31
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 40069 MS, Rate:   204.447, to /s3/GigaData.31
Data: Writing, 8192 MB, Buffer: 128 KB, Time: 40082 MS, Rate:   204.381, to /s1/GigaData.31


Fastest for filesystem s0 234.889 MB/s /s0/GigaData.8
Slowest for filesystem s0 140.464 MB/s /s0/GigaData.0
Fastest for filesystem s1 239.085 MB/s /s1/GigaData.13
Slowest for filesystem s1 140.454 MB/s /s1/GigaData.0
Fastest for filesystem s2 234.862 MB/s /s2/GigaData.8
Slowest for filesystem s2 140.462 MB/s /s2/GigaData.0
Fastest for filesystem s3 238.160 MB/s /s3/GigaData.8
Slowest for filesystem s3 140.380 MB/s /s3/GigaData.0
Max write speed (striped): 946.996
Min write speed (striped): 561.76



--------------060803090605060507010505
Content-Type: message/rfc822;
	 name="xfs write speed regression 2.6.18.1 to 2.6.19.1.eml"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	 filename="xfs write speed regression 2.6.18.1 to 2.6.19.1.eml"

Message-ID: <45951A1B.8070206@exegy.com>
Date: Fri, 29 Dec 2006 07:37:31 -0600
From: "Mr. Berkley Shands" <bshands@exegy.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061222)
MIME-Version: 1.0
To: xfs-masters@oss.sgi.com,  linux-kernel@vger.kernel.org
CC: Dave Lloyd <dlloyd@exegy.com>
Subject: xfs write speed regression 2.6.18.1 to 2.6.19.1
Content-Type: multipart/alternative;
 boundary="------------050406070902090104070606"

This is a multi-part message in MIME format.
--------------050406070902090104070606
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Write speeds have decreased 10% to 30% between 2.6.18.1 and 2.6.19.1.
Read speeds are unchanged at 1.15 GB/Sec.

Using a SuperMicro H8DC8 or Tyan 2895 or a Tyan 2915 (Socket F)
with 4 2.2GHz Opterons, 16GB RAM, dual LSI 8408E SAS controllers
into 4 X 4 Raid0s. XFS file system. The only difference is the Kernel Rev.
16 Seagate 7200.10 Sata drives, with 3.AAE firmware (very important!).
LSI 8408E firmware rev is 1.02.01-0158. Adapter readahead is disabled.
(Enabling readahead with this firmware costs 25% in write performance :-( )

Under 2.6.18.1, I/O peaks at 256.1 MB/Sec into each raid0 - 1GB/Sec.
The average is 230 MB/Sec over the first TB. With 2.6.19.1,
the peak is 220 MB/Sec, and the average is 170 MB/Sec.

EXT3 runs 2-3X slower than XFS for this benchmark, so it is hard
to see where the regression appeared. I'm not really too worried
about it, but that much of a decrease is worth reporting.
Since there were significant XFS changes between the revs,
it might not be worthwhile for me to chase the exact update
that causes this issue.

berkley


 
-- 

//E. F. Berkley Shands, MSc//

**Exegy Inc.**

3668 S. Geyer Road, Suite 300

St. Louis, MO  63127

Direct:  (314) 450-5348

Cell:  (314) 303-2546

Office:  (314) 450-5353

Fax:  (314) 450-5354

 

This e-mail and any documents accompanying it may contain legally 
privileged and/or confidential information belonging to Exegy, Inc.  
Such information may be protected from disclosure by law.  The 
information is intended for use by only the addressee.  If you are not 
the intended recipient, you are hereby notified that any disclosure or 
use of the information is strictly prohibited.  If you have received 
this e-mail in error, please immediately contact the sender by e-mail or 
phone regarding instructions for return or destruction and do not use or 
disclose the content to others.

 


--------------050406070902090104070606
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html;charset=ISO-8859-1" http-equiv="Content-Type">
  <title></title>
</head>
<body bgcolor="#ffffff" text="#000000">
<tt>Write speeds have decreased 10% to 30% between 2.6.18.1 and
2.6.19.1.<br>
Read speeds are unchanged at 1.15 GB/Sec.<br>
<br>
Using a SuperMicro H8DC8 or Tyan 2895 or a Tyan 2915 (Socket F)<br>
with 4 2.2GHz Opterons, 16GB RAM, dual LSI 8408E SAS controllers<br>
into 4 X 4 Raid0s. XFS file system. The only difference is the Kernel
Rev.<br>
16 Seagate 7200.10 Sata drives, with 3.AAE firmware (very important!).<br>
LSI 8408E firmware rev is 1.02.01-0158. Adapter readahead is disabled.<br>
(Enabling readahead with this firmware costs 25% in write performance
:-( )<br>
<br>
Under 2.6.18.1, I/O peaks at 256.1 MB/Sec into each raid0 - 1GB/Sec. <br>
The average is 230 MB/Sec over the first TB. With 2.6.19.1, <br>
the peak is 220 MB/Sec, and the average is 170 MB/Sec.<br>
<br>
EXT3 runs 2-3X slower than XFS for this benchmark, so it is hard<br>
to see where the regression appeared. I'm not really too worried<br>
about it, but that much of a decrease is worth reporting.<br>
Since there were significant XFS changes between the revs, <br>
it might not be worthwhile for me to chase the exact update<br>
that causes this issue.<br>
<br>
berkley<br>
<br>
<br>
&nbsp;<br>
</tt>
<div class="moz-signature">-- <br>
<meta http-equiv="Content-Type" content="text/html; ">
<meta content="MSHTML 6.00.2900.2802" name="GENERATOR">
<o:SmartTagType
 namespaceuri="urn:schemas-microsoft-com:office:smarttags" name="Street"></o:SmartTagType><o:SmartTagType
 namespaceuri="urn:schemas-microsoft-com:office:smarttags"
 name="PostalCode"></o:SmartTagType><o:SmartTagType
 namespaceuri="urn:schemas-microsoft-com:office:smarttags" name="State"></o:SmartTagType><o:SmartTagType
 namespaceuri="urn:schemas-microsoft-com:office:smarttags" name="City"></o:SmartTagType><o:SmartTagType
 namespaceuri="urn:schemas-microsoft-com:office:smarttags" name="place"></o:SmartTagType><o:SmartTagType
 namespaceuri="urn:schemas-microsoft-com:office:smarttags"
 name="address"></o:SmartTagType><o:SmartTagType
 namespaceuri="urn:schemas-microsoft-com:office:smarttags"
 name="PersonName"></o:SmartTagType><!--[if !mso]>
<STYLE>st1\:* {
	BEHAVIOR: url(#default#ieooui)
}
</STYLE>
<![endif]-->
<style>@font-face {
	font-family: Batang;
}
@font-face {
	font-family: Tahoma;
}
@font-face {
	font-family: @Batang;
}
@font-face {
	font-family: Arial Narrow;
}
@font-face {
	font-family: Garamond;
}
@font-face {
	font-family: Brush Script MT;
}
@page Section1 {size: 8.5in 11.0in; margin: 1.0in 1.25in 1.0in 1.25in; }
P.MsoNormal {
	FONT-SIZE: 12pt; MARGIN: 0in 0in 0pt; FONT-FAMILY: "Times New Roman"
}
LI.MsoNormal {
	FONT-SIZE: 12pt; MARGIN: 0in 0in 0pt; FONT-FAMILY: "Times New Roman"
}
DIV.MsoNormal {
	FONT-SIZE: 12pt; MARGIN: 0in 0in 0pt; FONT-FAMILY: "Times New Roman"
}
A:link {
	COLOR: blue; TEXT-DECORATION: underline
}
SPAN.MsoHyperlink {
	COLOR: blue; TEXT-DECORATION: underline
}
A:visited {
	COLOR: purple; TEXT-DECORATION: underline
}
SPAN.MsoHyperlinkFollowed {
	COLOR: purple; TEXT-DECORATION: underline
}
SPAN.EmailStyle17 {
	COLOR: windowtext; FONT-FAMILY: Arial; mso-style-type: personal-compose
}
DIV.Section1 {
	page: Section1
}
</style>
<div class="Section1">
<p class="MsoNormal" align="left"><font face="Arial" size="2"><span
 style="font-size: 10pt; font-family: Arial;"><o:p></o:p></span></font></p>
<p class="MsoNormal"><font face="Arial" size="2"><span
 style="font-size: 10pt; font-family: Arial;"><o:p></o:p></span></font></p>
<p class="MsoNormal" align="left"><st1:PersonName w:st="on"><em><i><font
 face="Brush Script MT" size="2"><span
 style="font-size: 10pt; font-family: 'Brush Script MT';">E. F. Berkley
Shands, MSc</span></font></i></em></st1:PersonName></p>
<p class="MsoNormal"><strong><b><font color="maroon" face="Arial Narrow"
 size="1"><span
 style="font-size: 7.5pt; color: maroon; font-family: 'Arial Narrow';">Exegy
Inc.</span></font></b></strong><font face="Arial Narrow"><span
 style="font-family: 'Arial Narrow';"><o:p></o:p></span></font></p>
<p class="MsoNormal"><ST1:STREET w:st="on"><ST1:ADDRESS w:st="on"><st1:Street
 w:st="on"><st1:address w:st="on"><font face="Arial Narrow" size="1"><span
 style="font-size: 7.5pt; font-family: 'Arial Narrow';">3668 S. Geyer
Road, Suite 300</span></font></st1:address></st1:Street></ST1:ADDRESS></ST1:STREET><font
 face="Arial Narrow"><span style="font-family: 'Arial Narrow';"><o:p></o:p></span></font></p>
<p class="MsoNormal"><ST1:PLACE w:st="on"><ST1:CITY w:st="on"><st1:place
 w:st="on"><st1:City w:st="on"><font face="Arial Narrow" size="1"><span
 style="font-size: 7.5pt; font-family: 'Arial Narrow';">St. Louis</span></font></st1:City></st1:place><font
 face="Arial Narrow" size="1"><span
 style="font-size: 7.5pt; font-family: 'Arial Narrow';"></span></font></ST1:CITY><font
 face="Arial Narrow" size="1">, <ST1:STATE w:st="on"><st1:State
 w:st="on">MO</st1:State></ST1:STATE>&nbsp; <ST1:POSTALCODE w:st="on"><st1:PostalCode
 w:st="on">63127</st1:PostalCode></ST1:POSTALCODE></font></ST1:PLACE><font
 face="Arial Narrow"><span style="font-family: 'Arial Narrow';"><o:p></o:p></span></font></p>
<p class="MsoNormal"><font face="Arial Narrow" size="1"><span
 style="font-size: 7.5pt; font-family: 'Arial Narrow';">Direct:&nbsp; (314)
450-5348</span></font></p>
<p class="MsoNormal"><font face="Arial Narrow" size="1"><span
 style="font-size: 7.5pt; font-family: 'Arial Narrow';">Cell:&nbsp; (314)
303-2546</span></font></p>
<p class="MsoNormal"><font face="Arial Narrow" size="1"><span
 style="font-size: 7.5pt; font-family: 'Arial Narrow';">Office:&nbsp; (314)
450-5353</span></font><font face="Arial Narrow"><span
 style="font-family: 'Arial Narrow';"><o:p></o:p></span></font></p>
<p class="MsoNormal"><font face="Arial Narrow" size="1"><span
 style="font-size: 7.5pt; font-family: 'Arial Narrow';">Fax:&nbsp; (314)
450-5354</span></font><font face="Arial Narrow"><span
 style="font-family: 'Arial Narrow';"><o:p></o:p></span></font></p>
<p class="MsoNormal"><font face="Arial Narrow" size="2"><span
 style="font-size: 10pt; font-family: 'Arial Narrow';"><o:p>&nbsp;</o:p></span></font></p>
<p class="MsoNormal"><font face="Arial Narrow" size="1"><span
 style="font-size: 8pt; font-family: 'Arial Narrow';">This e-mail and
any documents accompanying it may contain legally privileged and/or
confidential information belonging to Exegy, Inc.&nbsp; Such information may
be protected from disclosure by law.&nbsp; The information is intended for
use by only the addressee.&nbsp; If you are not the intended recipient, you
are hereby notified that any disclosure or use of the information is
strictly prohibited.&nbsp; If you have received this e-mail in error, please
immediately contact the sender by e-mail or phone regarding
instructions for return or destruction and do not use or disclose the
content to others.</span></font><font face="Arial Narrow"><span
 style="font-family: 'Arial Narrow';"> <o:p></o:p></span></font></p>
<p class="MsoNormal"><font face="Times New Roman" size="3"><span
 style="font-size: 12pt;"><o:p>&nbsp;</o:p></span></font></p>
</div>
</div>
</body>
</html>

--------------050406070902090104070606--



--------------060803090605060507010505--
