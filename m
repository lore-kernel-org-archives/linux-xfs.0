Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 11 Apr 2008 19:41:22 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3C2f27i027288
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2008 19:41:04 -0700
Received: from wf-out-1314.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4DCF312926E1
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2008 19:41:39 -0700 (PDT)
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.173]) by cuda.sgi.com with ESMTP id 6cgrUhZugWGSN9p2 for <xfs@oss.sgi.com>; Fri, 11 Apr 2008 19:41:39 -0700 (PDT)
Received: by wf-out-1314.google.com with SMTP id 29so819242wff.32
        for <xfs@oss.sgi.com>; Fri, 11 Apr 2008 19:41:39 -0700 (PDT)
Message-ID: <efe536470804111935q262008b4va3cf8143804936ed@mail.gmail.com>
Date: Fri, 11 Apr 2008 19:35:35 -0700
From: "Robert Navarro" <crshman@gmail.com>
Subject: lost+found Delete Error
MIME-Version: 1.0
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hello Everyone,

I'm having an issue deleting some files from lost+found....

crshman@mcepc:/media/Data/lost+found$ ls -la
total 352
drwxr-xr-x  4 crshman    crshman                307200 2008-04-11 11:51 .
drwxr-xr-x 11 crshman    crshman                 24576 2008-04-11 11:28 ..
drwxr-xr-x  3 crshman    root                       24 2008-04-11
11:19 1082386363
drwxrwxrwx  3 crshman    crshman                    16 2008-04-11
11:51 1153339163
-rwxr-xrw-  1   33622760   50332648    845524441880619 2007-10-11
01:36 2453227806
-rwxr-xr-t  1       1512  251670529               9116 2007-08-06
15:01 2840594848
-rwxr-xr-x  1 1174438352 1431656169 504510914699959044 1970-07-24
00:15 2887819688
-rwxr-xr-x  1 2686042304 1349606297 504546338931787648 2004-01-14
06:53 2887819692
-rwxr-xr-x  1 3222348776  829785687 504617807677724801 1901-12-16
17:38 2887819700
-rwxr-xr-x  1 3222348752        936 504546338916775344 1901-12-17
02:52 2887819703
-rwxr-xr-x  1 3222397921 2425389928 504511155016456306 1901-12-16
22:06 2887819704
-rwxr-xr-x  1 3222340584 3930769858 504546339569310213 1918-12-21
14:38 2887819705
-rwxr-xr-x  1  117457640 2667662080 504582622414146942 1905-09-24
11:53 2887819707
-rwxr-xr-x  1 3222397921        888 504510914481005384 1987-07-28
23:36 2887819708
--w--wxrw-  1 1280770657 3287811048               7080 2007-10-08
05:12 3038302590


crshman@mcepc:/media/Data/lost+found$ rm -fr *
rm: cannot remove directory `1082386363/56_Sim_Lane': Directory not empty
rm: cannot remove directory `1153339163/hl2/materials/Decals':
Directory not empty
rm: cannot remove `2453227806': Operation not permitted


crshman@mcepc:/media/Data/lost+found$ ls -la
total 352
drwxr-xr-x  4 crshman    crshman                307200 2008-04-11 11:51 .
drwxr-xr-x 11 crshman    crshman                 24576 2008-04-11 11:28 ..
drwxr-xr-x  3 crshman    root                       24 2008-04-11
11:19 1082386363
drwxrwxrwx  3 crshman    crshman                    16 2008-04-11
11:51 1153339163
-rwxr-xrw-  1   33622760   50332648    845524441880619 2007-10-11
01:36 2453227806
-rwxr-xr-t  1       1512  251670529               9116 2007-08-06
15:01 2840594848
-rwxr-xr-x  1 1174438352 1431656169 504510914699959044 1970-07-24
00:15 2887819688
-rwxr-xr-x  1 2686042304 1349606297 504546338931787648 2004-01-14
06:53 2887819692
-rwxr-xr-x  1 3222348776  829785687 504617807677724801 1901-12-16
17:38 2887819700
-rwxr-xr-x  1 3222348752        936 504546338916775344 1901-12-17
02:52 2887819703
-rwxr-xr-x  1 3222397921 2425389928 504511155016456306 1901-12-16
22:06 2887819704
-rwxr-xr-x  1 3222340584 3930769858 504546339569310213 1918-12-21
14:38 2887819705
-rwxr-xr-x  1  117457640 2667662080 504582622414146942 1905-09-24
11:53 2887819707
-rwxr-xr-x  1 3222397921        888 504510914481005384 1987-07-28
23:36 2887819708
--w--wxrw-  1 1280770657 3287811048               7080 2007-10-08
05:12 3038302590
crshman@mcepc:/media/Data/lost+found$

Any ideas?

I've tried unmounting, and remounting the file system with no luck

-- 
~Robert Navarro


[[HTML alternate version deleted]]
