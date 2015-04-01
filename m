Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 825387F60
	for <xfs@oss.sgi.com>; Wed,  1 Apr 2015 14:53:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1AE7DAC001
	for <xfs@oss.sgi.com>; Wed,  1 Apr 2015 12:53:37 -0700 (PDT)
Received: from mail-qc0-f173.google.com (mail-qc0-f173.google.com
	[209.85.216.173]) by cuda.sgi.com with ESMTP id
	kyGoTO0fpMY9kQSQ (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 01 Apr 2015 12:53:31 -0700 (PDT)
Received: by qcay5 with SMTP id y5so50657350qca.1
	for <xfs@oss.sgi.com>; Wed, 01 Apr 2015 12:53:30 -0700 (PDT)
Message-ID: <551C4CB8.7@binghamton.edu>
Date: Wed, 01 Apr 2015 15:53:28 -0400
From: Dave Hall <kdhall@binghamton.edu>
MIME-Version: 1.0
Subject: Re: Slightly Urgent:  XFS No Space Left On Device
References: <551993CF.4060908@binghamton.edu> <20150330194510.GD28621@dastard>
In-Reply-To: <20150330194510.GD28621@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2251610587146040100=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--===============2251610587146040100==
Content-Type: multipart/alternative;
 boundary="------------000606080309030203050905"

This is a multi-part message in MIME format.
--------------000606080309030203050905
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Please pardon the 'top-post', but here is the additional information 
requested:

This is a Dell R720xd dual 8-core Xeon system with 128GB RAM.  The RAID 
controller is Dell PERC H710 Mini with 12 2TB disks in RAID6.

The OS is Debian 6 with kernel 3.2.0-0.bpo.4-amd64 #1 SMP Debian 
3.2.65-1+deb7u2~bpo60+1 x86_64.

 From /proc/mounts:

    /dev/sdb1 /data xfs
    rw,noexec,noatime,attr2,delaylog,allocsize=64k,logbsize=64k,sunit=128,swidth=1280,usrquota,prjquota
    0 0

Content-wise there are 7 first level directories.  Four contain just a 
couple files.  One of these has a 4.9TB file in it.  The other 3 
directories are multi-terabyte, but contain many hundreds of thousands 
of smaller files.  There are nearly 5 million files in about 6500 
directories, but less than 500 files are over 1GB in size, with only 200 
over 20GB and less than 10 over 1TB.

The output from xfs_info was previously included, but is repeated here:

        # xfs_info /data
        meta-data=/dev/sdb1              isize=256    agcount=19,
        agsize=268435440 blks
                  =                       sectsz=512   attr=2
        data     =                       bsize=4096 blocks=4882431488, imaxpct=5
                  =                       sunit=16     swidth=160 blks
        naming   =version 2              bsize=4096   ascii-ci=0
        log      =internal               bsize=4096   blocks=521728, version=2
                  =                       sectsz=512   sunit=16 blks,
        lazy-count=1
        realtime =none                   extsz=4096   blocks=0, rtextents=0

        # df -h .
        Filesystem            Size  Used Avail Use% Mounted on
        /dev/sdb1              19T   12T  7.0T  62% /data
        # df -ih .
        Filesystem            Inodes   IUsed   IFree IUse% Mounted on
        /dev/sdb1               3.7G    4.7M    3.7G    1% /data
       

Here are the more extensive freesp outputs for each of the 19 AGs:

    # xfs_db -r /dev/sdb1 -c 'freesp -s -a0'
        from      to extents  blocks    pct
           1       1     747     747  19.68
           2       3    1045    2496  65.77
           4       7     138     552  14.55
    total free extents 1930
    total free blocks 3795
    average free extent size 1.96632

(I don't recall the output from AG0 being so terse on Monday when I 
first posted, but the summary information is the same.)

    # xfs_db -r /dev/sdb1 -c 'freesp -s -a1'
        from      to extents  blocks    pct
           1       1    4494    4494   0.00
           2       3   42096   91313   0.05
           4       7   41096  232953   0.13
           8      15  121930 1401067   0.81
          16      31   44994 1067002   0.61
          32      63       4     209   0.00
          64     127      20    1888   0.00
         128     255      38    7408   0.00
         256     511   14728 5936038   3.41
         512    1023     308  246748   0.14
        1024    2047   14893 22978919  13.22
        2048    4095    1229 4118315   2.37
        4096    8191     778 4743029   2.73
        8192   16383     329 3694322   2.13
       16384   32767      51 1098154   0.63
       32768   65535       3   98794   0.06
       65536  131071       3  275197   0.16
      131072  262143       4  957177   0.55
    1048576 2097151       1 1968807   1.13
    2097152 4194303       1 3085945   1.78
    4194304 8388607       1 5131888   2.95
    8388608 16777215       3 33124064  19.06
    16777216 33554431       1 28684574  16.50
    33554432 67108863       1 54883950  31.57
    total free extents 287006
    total free blocks 173832255
    average free extent size 605.675

    # xfs_db -r /dev/sdb1 -c 'freesp -s -a2'
        from      to extents  blocks    pct
           1       1    5695    5695   0.01
           2       3   15405   39309   0.04
           4       7   52230  296302   0.31
           8      15  112686 1303036   1.38
          16      31     967   20943   0.02
          32      63      67    2983   0.00
          64     127     343   31251   0.03
         128     255     100   17428   0.02
         256     511   76672 30821379  32.69
         512    1023       4    2800   0.00
        1024    2047    7537 11762194  12.47
        2048    4095     326 1130975   1.20
        4096    8191     251 1615591   1.71
        8192   16383     105 1184516   1.26
       16384   32767      14  274014   0.29
       65536  131071       1   73535   0.08
      131072  262143       1  234632   0.25
      262144  524287       2  788639   0.84
      524288 1048575       1  738305   0.78
    1048576 2097151      17 34302421  36.38
    8388608 16777215       1 9645304  10.23
    total free extents 272425
    total free blocks 94291252

    # xfs_db -r /dev/sdb1 -c 'freesp -s -a3'
        from      to extents  blocks    pct
           1       1    5793    5793   0.01
           2       3   30667   70359   0.06
           4       7   53174  301241   0.27
           8      15  129098 1480652   1.34
          16      31    4875  116797   0.11
          32      63     148    6755   0.01
          64     127   13192 1200672   1.09
         128     255    1754  286342   0.26
         256     511   35132 14122824  12.81
         512    1023       6    4349   0.00
        1024    2047   11609 18155617  16.47
        2048    4095     447 1557312   1.41
        4096    8191     342 2120360   1.92
        8192   16383     147 1685429   1.53
       16384   32767      21  438149   0.40
       32768   65535       5  221907   0.20
       65536  131071       4  384869   0.35
      131072  262143       3  576503   0.52
      524288 1048575       1  524974   0.48
    1048576 2097151       2 2718327   2.47
    33554432 67108863       1 64229173  58.28
    total free extents 286421
    total free blocks 110208404
    average free extent size 384.778

    # xfs_db -r /dev/sdb1 -c 'freesp -s -a4'
        from      to extents  blocks    pct
           1       1    5399    5399   0.01
           2       3   29098   67289   0.06
           4       7   50889  287977   0.27
           8      15  125018 1433485   1.34
          16      31    4601  108565   0.10
          32      63      86    3986   0.00
          64     127   12587 1145709   1.07
         128     255    1537  250472   0.23
         256     511   35982 14464615  13.50
         512    1023       2    1039   0.00
        1024    2047   11074 17306417  16.16
        2048    4095     428 1488906   1.39
        4096    8191     343 2130436   1.99
        8192   16383     141 1574556   1.47
       16384   32767      22  437491   0.41
       32768   65535       2   74530   0.07
       65536  131071       2  198418   0.19
      131072  262143       2  399680   0.37
      262144  524287       1  278259   0.26
      524288 1048575       1  858623   0.80
    2097152 4194303       1 2357798   2.20
    4194304 8388607       1 7007241   6.54
    8388608 16777215       2 24665312  23.03
    16777216 33554431       1 30572144  28.54
    total free extents 277220
    total free blocks 107118347
    average free extent size 386.402

    # xfs_db -r /dev/sdb1 -c 'freesp -s -a5'
        from      to extents  blocks    pct
           1       1    5623    5623   0.01
           2       3   28053   65224   0.06
           4       7   51000  288250   0.27
           8      15  122593 1405739   1.32
          16      31    4439  104165   0.10
          32      63     107    4913   0.00
          64     127   10904  992287   0.93
         128     255    1458  237872   0.22
         256     511   37480 15066766  14.19
         512    1023       4    3298   0.00
        1024    2047   11035 17206454  16.20
        2048    4095     416 1447533   1.36
        4096    8191     367 2264983   2.13
        8192   16383     132 1507258   1.42
       16384   32767      17  369018   0.35
       32768   65535       5  252737   0.24
       65536  131071       1   93292   0.09
      131072  262143       2  369218   0.35
      262144  524287       1  371390   0.35
    8388608 16777215       1 11907027  11.21
    16777216 33554431       1 17447945  16.43
    33554432 67108863       1 34801264  32.77
    total free extents 273640
    total free blocks 106212256
    average free extent size 388.146

    # xfs_db -r /dev/sdb1 -c 'freesp -s -a6'
        from      to extents  blocks    pct
           1       1    5485    5485   0.01
           2       3   28092   65622   0.06
           4       7   51124  288408   0.27
           8      15  122946 1411945   1.32
          16      31    4295   99036   0.09
          32      63     136    6165   0.01
          64     127   10723  975901   0.91
         128     255    1393  227148   0.21
         256     511   37816 15202240  14.21
         512    1023       9    6955   0.01
        1024    2047   11001 17139027  16.02
        2048    4095     452 1570875   1.47
        4096    8191     310 1937437   1.81
        8192   16383     140 1622878   1.52
       16384   32767      22  432606   0.40
       32768   65535       3  119928   0.11
       65536  131071       2  201539   0.19
      131072  262143       1  242792   0.23
      524288 1048575       2 1642283   1.53
    1048576 2097151       2 2522760   2.36
    4194304 8388607       2 9405762   8.79
    16777216 33554431       2 51878521  48.48
    total free extents 273958
    total free blocks 107005313
    average free extent size 390.59

    # xfs_db -r /dev/sdb1 -c 'freesp -s -a7'
        from      to extents  blocks    pct
           1       1    5728    5728   0.01
           2       3   27342   63963   0.06
           4       7   51098  288588   0.27
           8      15  122083 1400413   1.29
          16      31    4154   95945   0.09
          32      63     125    5696   0.01
          64     127   10490  954737   0.88
         128     255    1377  225554   0.21
         256     511   38215 15362799  14.12
         512    1023       5    3014   0.00
        1024    2047   11138 17383490  15.98
        2048    4095     446 1547400   1.42
        4096    8191     314 1940099   1.78
        8192   16383     138 1553781   1.43
       16384   32767      26  526808   0.48
       32768   65535       5  198738   0.18
       65536  131071       3  306072   0.28
      131072  262143       1  204457   0.19
      524288 1048575       1  675084   0.62
    4194304 8388607       1 6256240   5.75
    8388608 16777215       1 16700425  15.35
    16777216 33554431       2 43106323  39.62
    total free extents 272693
    total free blocks 108805354
    average free extent size 399.003

    # xfs_db -r /dev/sdb1 -c 'freesp -s -a8'
        from      to extents  blocks    pct
           1       1    5545    5545   0.01
           2       3   27537   64379   0.06
           4       7   50486  284834   0.28
           8      15  121719 1398087   1.35
          16      31    4169   96146   0.09
          32      63     140    6404   0.01
          64     127   10168  925246   0.90
         128     255    1347  219934   0.21
         256     511   38396 15435162  14.96
         512    1023       9    6657   0.01
        1024    2047   11038 17234155  16.70
        2048    4095     411 1427988   1.38
        4096    8191     337 2110360   2.04
        8192   16383     134 1540661   1.49
       16384   32767      29  608663   0.59
       32768   65535       4  194772   0.19
       65536  131071       1  103722   0.10
      131072  262143       1  204540   0.20
    1048576 2097151       1 1177573   1.14
    16777216 33554431       1 19036961  18.45
    33554432 67108863       1 41120777  39.84
    total free extents 271474
    total free blocks 103202566
    average free extent size 380.156

    # xfs_db -r /dev/sdb1 -c 'freesp -s -a9'
        from      to extents  blocks    pct
           1       1    5614    5614   0.01
           2       3   27343   63817   0.06
           4       7   50789  286921   0.26
           8      15  122085 1402116   1.28
          16      31    4116   95310   0.09
          32      63     152    6954   0.01
          64     127   10679  971872   0.89
         128     255    1315  215145   0.20
         256     511   38557 15499672  14.19
         512    1023       6    4435   0.00
        1024    2047   11119 17330956  15.86
        2048    4095     428 1485414   1.36
        4096    8191     313 1932235   1.77
        8192   16383     158 1823615   1.67
       16384   32767      20  427607   0.39
       32768   65535       4  162954   0.15
       65536  131071       1   74125   0.07
      262144  524287       2  782823   0.72
      524288 1048575       1  979230   0.90
    4194304 8388607       1 6064549   5.55
    33554432 67108863       1 59625070  54.58
    total free extents 272704
    total free blocks 109240434
    average free extent size 400.582

    # xfs_db -r /dev/sdb1 -c 'freesp -s -a10'
        from      to extents  blocks    pct
           1       1    5451    5451   0.01
           2       3   27619   64469   0.06
           4       7   50888  287306   0.27
           8      15  122129 1401775   1.30
          16      31    4156   96465   0.09
          32      63     112    5115   0.00
          64     127   10378  944415   0.87
         128     255    1336  218180   0.20
         256     511   38056 15298154  14.15
         512    1023       6    3630   0.00
        1024    2047   10908 17025890  15.75
        2048    4095     443 1541035   1.43
        4096    8191     326 2036141   1.88
        8192   16383     150 1670607   1.55
       16384   32767      23  497495   0.46
       32768   65535       6  259503   0.24
       65536  131071       1   80765   0.07
      131072  262143       2  466041   0.43
    8388608 16777215       2 24552174  22.72
    16777216 33554431       2 41626231  38.51
    total free extents 271994
    total free blocks 108080842
    average free extent size 397.365

    # xfs_db -r /dev/sdb1 -c 'freesp -s -a11'
        from      to extents  blocks    pct
           1       1    5753    5753   0.01
           2       3   28506   66164   0.06
           4       7   51222  289018   0.27
           8      15  122115 1400237   1.31
          16      31    4325  100622   0.09
          32      63     121    5515   0.01
          64     127   11218 1020941   0.95
         128     255    1419  231469   0.22
         256     511   37233 14967258  13.96
         512    1023      13   10433   0.01
        1024    2047   11040 17243570  16.08
        2048    4095     438 1528105   1.42
        4096    8191     313 1948122   1.82
        8192   16383     137 1545209   1.44
       16384   32767      17  340315   0.32
       32768   65535       3  135239   0.13
      524288 1048575       1  806510   0.75
    1048576 2097151       1 1670160   1.56
    2097152 4194303       1 3359120   3.13
    4194304 8388607       1 4927086   4.59
    8388608 16777215       2 26372734  24.59
    16777216 33554431       1 29269614  27.29
    total free extents 273880
    total free blocks 107243194
    average free extent size 391.57

    # xfs_db -r /dev/sdb1 -c 'freesp -s -a12'
        from      to extents  blocks    pct
           1       1    5373    5373   0.01
           2       3   27530   64216   0.06
           4       7   50788  286603   0.27
           8      15  121652 1396720   1.31
          16      31    4188   97008   0.09
          32      63      71    3299   0.00
          64     127   10446  950836   0.89
         128     255    1349  220210   0.21
         256     511   37835 15209592  14.28
         512    1023       1     918   0.00
        1024    2047   10950 17087135  16.04
        2048    4095     416 1445170   1.36
        4096    8191     341 2103801   1.98
        8192   16383     146 1643458   1.54
       16384   32767      27  551354   0.52
       32768   65535       5  173876   0.16
       65536  131071       3  273193   0.26
      262144  524287       2  695714   0.65
      524288 1048575       2 1740580   1.63
    16777216 33554431       1 22797321  21.40
    33554432 67108863       1 39761770  37.33
    total free extents 271127
    total free blocks 106508147
    average free extent size 392.835

    # xfs_db -r /dev/sdb1 -c 'freesp -s -a13'
        from      to extents  blocks    pct
           1       1    5756    5756   0.01
           2       3   27074   63268   0.06
           4       7   50796  287174   0.26
           8      15  121675 1397015   1.28
          16      31    4260   98417   0.09
          32      63     136    6191   0.01
          64     127   10324  939549   0.86
         128     255    1315  215314   0.20
         256     511   39195 15756002  14.40
         512    1023       8    5675   0.01
        1024    2047   11129 17335479  15.84
        2048    4095     419 1457554   1.33
        4096    8191     321 2012733   1.84
        8192   16383     143 1666063   1.52
       16384   32767      23  460740   0.42
       32768   65535       2  103286   0.09
       65536  131071       2  193585   0.18
      262144  524287       1  356370   0.33
    33554432 67108863       1 67081225  61.29
    total free extents 272580
    total free blocks 109441396
    average free extent size 401.502

    # xfs_db -r /dev/sdb1 -c 'freesp -s -a14'
        from      to extents  blocks    pct
           1       1    5585    5585   0.01
           2       3   26740   62793   0.06
           4       7   50781  286750   0.27
           8      15  120804 1388061   1.30
          16      31    4186   96930   0.09
          32      63     160    7192   0.01
          64     127    9898  900897   0.84
         128     255    1318  215049   0.20
         256     511   38427 15446911  14.48
         512    1023       7    4130   0.00
        1024    2047   11116 17330340  16.25
        2048    4095     390 1356701   1.27
        4096    8191     307 1917633   1.80
        8192   16383     150 1679866   1.57
       16384   32767      24  490742   0.46
       32768   65535       3  156921   0.15
       65536  131071       3  290496   0.27
      524288 1048575       1  715032   0.67
    1048576 2097151       1 1570472   1.47
    33554432 67108863       1 62750353  58.83
    total free extents 269902
    total free blocks 106672854
    average free extent size 395.228

    # xfs_db -r /dev/sdb1 -c 'freesp -s -a15'
        from      to extents  blocks    pct
           1       1    5734    5734   0.01
           2       3   15777   40616   0.05
           4       7   51372  290289   0.39
           8      15  121640 1396823   1.88
          16      31    3105   69153   0.09
          32      63      14     700   0.00
          64     127      19    1760   0.00
         128     255    3157  530350   0.71
         256     511      18    7797   0.01
         512    1023       7    4504   0.01
        1024    2047   44155 71890115  96.61
        2048    4095       5   13601   0.02
        4096    8191       4   20168   0.03
        8192   16383       3   24586   0.03
       16384   32767       4   80524   0.11
       32768   65535       1   37430   0.05
    total free extents 245015
    total free blocks 74414150
    average free extent size 303.713

    # xfs_db -r /dev/sdb1 -c 'freesp -s -a16'
        from      to extents  blocks    pct
           1       1    5458    5458   0.01
           2       3   29896   69017   0.07
           4       7   50646  286147   0.28
           8      15  123250 1414603   1.37
          16      31    4257   99155   0.10
          32      63     112    5139   0.00
          64     127   13228 1203844   1.17
         128     255    1363  222544   0.22
         256     511   31264 12567433  12.17
         512    1023       8    5911   0.01
        1024    2047   11091 17306832  16.76
        2048    4095     452 1573760   1.52
        4096    8191     356 2239416   2.17
        8192   16383     135 1522673   1.47
       16384   32767      17  350269   0.34
       32768   65535       3  122543   0.12
       65536  131071       3  374987   0.36
      131072  262143       5 1169749   1.13
      524288 1048575       2 1884165   1.83
    1048576 2097151       1 1237015   1.20
    8388608 16777215       1 9194667   8.91
    16777216 33554431       2 50384042  48.80
    total free extents 271550
    total free blocks 103239369
    average free extent size 380.185

    # xfs_db -r /dev/sdb1 -c 'freesp -s -a17'
        from      to extents  blocks    pct
           1       1    5788    5788   0.01
           2       3   26404   61921   0.06
           4       7   50904  287563   0.27
           8      15  120710 1385219   1.30
          16      31    4204   97175   0.09
          32      63      76    3490   0.00
          64     127   10045  914186   0.86
         128     255    1392  228552   0.21
         256     511   36867 14820192  13.90
         512    1023       7    4938   0.00
        1024    2047   11286 17637792  16.54
        2048    4095     441 1532071   1.44
        4096    8191     334 2078958   1.95
        8192   16383     123 1419610   1.33
       16384   32767      19  396082   0.37
       32768   65535       5  224967   0.21
       65536  131071       4  362807   0.34
      131072  262143       1  155224   0.15
      262144  524287       2  866414   0.81
      524288 1048575       1  999449   0.94
    1048576 2097151       1 1158766   1.09
    2097152 4194303       1 2528878   2.37
    8388608 16777215       3 39151859  36.72
    16777216 33554431       1 20313097  19.05
    total free extents 268619
    total free blocks 106634998
    average free extent size 396.975

    # xfs_db -r /dev/sdb1 -c 'freesp -s -a18'
        from      to extents  blocks    pct
           1       1    5588    5588   0.03
           2       3   24900   58887   0.32
           4       7   50929  287739   1.56
           8      15  120592 1386142   7.52
          16      31    4089   93924   0.51
          32      63     141    6372   0.03
          64     127    8468  770640   4.18
         128     255    1339  218783   1.19
         256     511      22    8582   0.05
         512    1023       4    2711   0.01
        1024    2047    9719 15333235  83.15
        2048    4095       4   10960   0.06
        4096    8191       1    4097   0.02
        8192   16383       1    8769   0.05
       16384   32767       2   32791   0.18
       32768   65535       5  210714   1.14
    total free extents 225804
    total free blocks 18439934
    average free extent size 81.6635

Dave Hall
Binghamton University
kdhall@binghamton.edu
607-760-2328 (Cell)
607-777-4641 (Office)


On 03/30/2015 03:45 PM, Dave Chinner wrote:
> On Mon, Mar 30, 2015 at 02:19:59PM -0400, Dave Hall wrote:
>    
>> Hello,
>>
>> I have an XFS file system that's getting 'No space left on device'
>> errors.  xfs_fsr also complains of 'No space left'.  The XFS Info
>> is:
>>
>>     # xfs_info /data
>>     meta-data=/dev/sdb1              isize=256    agcount=19,
>>     agsize=268435440 blks
>>               =                       sectsz=512   attr=2
>>     data     =                       bsize=4096 blocks=4882431488, imaxpct=5
>>               =                       sunit=16     swidth=160 blks
>>     naming   =version 2              bsize=4096   ascii-ci=0
>>     log      =internal               bsize=4096   blocks=521728, version=2
>>               =                       sectsz=512   sunit=16 blks,
>>     lazy-count=1
>>     realtime =none                   extsz=4096   blocks=0, rtextents=0
>>
>>     # df -h .
>>     Filesystem            Size  Used Avail Use% Mounted on
>>     /dev/sdb1              19T   12T  7.0T  62% /data
>>     # df -ih .
>>     Filesystem            Inodes   IUsed   IFree IUse% Mounted on
>>     /dev/sdb1               3.7G    4.7M    3.7G    1% /data
>>
>>
>> xfs_db freesp shows that AG 0 seems to be full.  I've included the
>> freesp for the first few AGs, but the rest seem pretty consistent
>> with AGs 1 - 4 that I've included below.
>>
>>     xfs_db>  freesp -s -e 1000000000 -a 0
>>      
> Can you please drop the "-e 1000000" from these commands and post it
> again?  The histogram of differing free space sizes is information
> we actually need to diagnose the problem...
>
> Also, kernel version, mount options and machine details are
> necessary to determine why AG0 might be full (e.g. allocation policy
> in use).
>
> Cheers,
>
> Dave.
>    

--------------000606080309030203050905
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html; charset=ISO-8859-1"
 http-equiv="Content-Type">
</head>
<body bgcolor="#ffffff" text="#000000">
Please pardon the 'top-post', but here is the additional information
requested:<br>
<br>
This is a Dell R720xd dual 8-core Xeon system with 128GB RAM.&nbsp; The RAID
controller is Dell PERC H710 Mini with 12 2TB disks in RAID6.<br>
<br>
The OS is Debian 6 with kernel 3.2.0-0.bpo.4-amd64 #1 SMP Debian
3.2.65-1+deb7u2~bpo60+1 x86_64.<br>
<br>
>From /proc/mounts: <br>
<blockquote><tt>/dev/sdb1 /data xfs
rw,noexec,noatime,attr2,delaylog,allocsize=64k,logbsize=64k,sunit=128,swidth=1280,usrquota,prjquota
0 0</tt><br>
</blockquote>
Content-wise there are 7 first level directories.&nbsp; Four contain just a
couple files.&nbsp; One of these has a 4.9TB file in it.&nbsp; The other 3
directories are multi-terabyte, but contain many hundreds of thousands
of smaller files.&nbsp; There are nearly 5 million files in about 6500
directories, but less than 500 files are over 1GB in size, with only
200 over 20GB and less than 10 over 1TB.<br>
<br>
The output from xfs_info was previously included, but is repeated here:<br>
<blockquote>
  <pre wrap="">   # xfs_info /data
   meta-data=/dev/sdb1              isize=256    agcount=19,
   agsize=268435440 blks
             =                       sectsz=512   attr=2
   data     =                       bsize=4096 blocks=4882431488, imaxpct=5
             =                       sunit=16     swidth=160 blks
   naming   =version 2              bsize=4096   ascii-ci=0
   log      =internal               bsize=4096   blocks=521728, version=2
             =                       sectsz=512   sunit=16 blks,
   lazy-count=1
   realtime =none                   extsz=4096   blocks=0, rtextents=0

   # df -h .
   Filesystem            Size  Used Avail Use% Mounted on
   /dev/sdb1              19T   12T  7.0T  62% /data
   # df -ih .
   Filesystem            Inodes   IUsed   IFree IUse% Mounted on
   /dev/sdb1               3.7G    4.7M    3.7G    1% /data
  </pre>
</blockquote>
Here are the more extensive freesp outputs for each of the 19 AGs:<br>
<blockquote><tt># xfs_db -r /dev/sdb1 -c 'freesp -s -a0'<br>
&nbsp;&nbsp; from&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; to extents&nbsp; blocks&nbsp;&nbsp;&nbsp; pct<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp;&nbsp;&nbsp; 747&nbsp;&nbsp;&nbsp;&nbsp; 747&nbsp; 19.68<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3&nbsp;&nbsp;&nbsp; 1045&nbsp;&nbsp;&nbsp; 2496&nbsp; 65.77<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 7&nbsp;&nbsp;&nbsp;&nbsp; 138&nbsp;&nbsp;&nbsp;&nbsp; 552&nbsp; 14.55<br>
total free extents 1930<br>
total free blocks 3795<br>
average free extent size 1.96632<br>
  </tt></blockquote>
(I don't recall the output from AG0 being so terse on Monday when I
first posted, but the summary information is the same.)<br>
<blockquote><tt># xfs_db -r /dev/sdb1 -c 'freesp -s -a1'<br>
&nbsp;&nbsp; from&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; to extents&nbsp; blocks&nbsp;&nbsp;&nbsp; pct<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp;&nbsp; 4494&nbsp;&nbsp;&nbsp; 4494&nbsp;&nbsp; 0.00<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3&nbsp;&nbsp; 42096&nbsp;&nbsp; 91313&nbsp;&nbsp; 0.05<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 7&nbsp;&nbsp; 41096&nbsp; 232953&nbsp;&nbsp; 0.13<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 15&nbsp; 121930 1401067&nbsp;&nbsp; 0.81<br>
&nbsp;&nbsp;&nbsp;&nbsp; 16&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 31&nbsp;&nbsp; 44994 1067002&nbsp;&nbsp; 0.61<br>
&nbsp;&nbsp;&nbsp;&nbsp; 32&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 63&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4&nbsp;&nbsp;&nbsp;&nbsp; 209&nbsp;&nbsp; 0.00<br>
&nbsp;&nbsp;&nbsp;&nbsp; 64&nbsp;&nbsp;&nbsp;&nbsp; 127&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 20&nbsp;&nbsp;&nbsp; 1888&nbsp;&nbsp; 0.00<br>
&nbsp;&nbsp;&nbsp; 128&nbsp;&nbsp;&nbsp;&nbsp; 255&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 38&nbsp;&nbsp;&nbsp; 7408&nbsp;&nbsp; 0.00<br>
&nbsp;&nbsp;&nbsp; 256&nbsp;&nbsp;&nbsp;&nbsp; 511&nbsp;&nbsp; 14728 5936038&nbsp;&nbsp; 3.41<br>
&nbsp;&nbsp;&nbsp; 512&nbsp;&nbsp;&nbsp; 1023&nbsp;&nbsp;&nbsp;&nbsp; 308&nbsp; 246748&nbsp;&nbsp; 0.14<br>
&nbsp;&nbsp; 1024&nbsp;&nbsp;&nbsp; 2047&nbsp;&nbsp; 14893 22978919&nbsp; 13.22<br>
&nbsp;&nbsp; 2048&nbsp;&nbsp;&nbsp; 4095&nbsp;&nbsp;&nbsp; 1229 4118315&nbsp;&nbsp; 2.37<br>
&nbsp;&nbsp; 4096&nbsp;&nbsp;&nbsp; 8191&nbsp;&nbsp;&nbsp;&nbsp; 778 4743029&nbsp;&nbsp; 2.73<br>
&nbsp;&nbsp; 8192&nbsp;&nbsp; 16383&nbsp;&nbsp;&nbsp;&nbsp; 329 3694322&nbsp;&nbsp; 2.13<br>
&nbsp; 16384&nbsp;&nbsp; 32767&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 51 1098154&nbsp;&nbsp; 0.63<br>
&nbsp; 32768&nbsp;&nbsp; 65535&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3&nbsp;&nbsp; 98794&nbsp;&nbsp; 0.06<br>
&nbsp; 65536&nbsp; 131071&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3&nbsp; 275197&nbsp;&nbsp; 0.16<br>
&nbsp;131072&nbsp; 262143&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4&nbsp; 957177&nbsp;&nbsp; 0.55<br>
1048576 2097151&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1 1968807&nbsp;&nbsp; 1.13<br>
2097152 4194303&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1 3085945&nbsp;&nbsp; 1.78<br>
4194304 8388607&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1 5131888&nbsp;&nbsp; 2.95<br>
8388608 16777215&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3 33124064&nbsp; 19.06<br>
16777216 33554431&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1 28684574&nbsp; 16.50<br>
33554432 67108863&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1 54883950&nbsp; 31.57<br>
total free extents 287006<br>
total free blocks 173832255<br>
average free extent size 605.675<br>
  <br>
# xfs_db -r /dev/sdb1 -c 'freesp -s -a2'<br>
&nbsp;&nbsp; from&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; to extents&nbsp; blocks&nbsp;&nbsp;&nbsp; pct<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp;&nbsp; 5695&nbsp;&nbsp;&nbsp; 5695&nbsp;&nbsp; 0.01<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3&nbsp;&nbsp; 15405&nbsp;&nbsp; 39309&nbsp;&nbsp; 0.04<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 7&nbsp;&nbsp; 52230&nbsp; 296302&nbsp;&nbsp; 0.31<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 15&nbsp; 112686 1303036&nbsp;&nbsp; 1.38<br>
&nbsp;&nbsp;&nbsp;&nbsp; 16&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 31&nbsp;&nbsp;&nbsp;&nbsp; 967&nbsp;&nbsp; 20943&nbsp;&nbsp; 0.02<br>
&nbsp;&nbsp;&nbsp;&nbsp; 32&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 63&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 67&nbsp;&nbsp;&nbsp; 2983&nbsp;&nbsp; 0.00<br>
&nbsp;&nbsp;&nbsp;&nbsp; 64&nbsp;&nbsp;&nbsp;&nbsp; 127&nbsp;&nbsp;&nbsp;&nbsp; 343&nbsp;&nbsp; 31251&nbsp;&nbsp; 0.03<br>
&nbsp;&nbsp;&nbsp; 128&nbsp;&nbsp;&nbsp;&nbsp; 255&nbsp;&nbsp;&nbsp;&nbsp; 100&nbsp;&nbsp; 17428&nbsp;&nbsp; 0.02<br>
&nbsp;&nbsp;&nbsp; 256&nbsp;&nbsp;&nbsp;&nbsp; 511&nbsp;&nbsp; 76672 30821379&nbsp; 32.69<br>
&nbsp;&nbsp;&nbsp; 512&nbsp;&nbsp;&nbsp; 1023&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4&nbsp;&nbsp;&nbsp; 2800&nbsp;&nbsp; 0.00<br>
&nbsp;&nbsp; 1024&nbsp;&nbsp;&nbsp; 2047&nbsp;&nbsp;&nbsp; 7537 11762194&nbsp; 12.47<br>
&nbsp;&nbsp; 2048&nbsp;&nbsp;&nbsp; 4095&nbsp;&nbsp;&nbsp;&nbsp; 326 1130975&nbsp;&nbsp; 1.20<br>
&nbsp;&nbsp; 4096&nbsp;&nbsp;&nbsp; 8191&nbsp;&nbsp;&nbsp;&nbsp; 251 1615591&nbsp;&nbsp; 1.71<br>
&nbsp;&nbsp; 8192&nbsp;&nbsp; 16383&nbsp;&nbsp;&nbsp;&nbsp; 105 1184516&nbsp;&nbsp; 1.26<br>
&nbsp; 16384&nbsp;&nbsp; 32767&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 14&nbsp; 274014&nbsp;&nbsp; 0.29<br>
&nbsp; 65536&nbsp; 131071&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp; 73535&nbsp;&nbsp; 0.08<br>
&nbsp;131072&nbsp; 262143&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp; 234632&nbsp;&nbsp; 0.25<br>
&nbsp;262144&nbsp; 524287&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2&nbsp; 788639&nbsp;&nbsp; 0.84<br>
&nbsp;524288 1048575&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp; 738305&nbsp;&nbsp; 0.78<br>
1048576 2097151&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 17 34302421&nbsp; 36.38<br>
8388608 16777215&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1 9645304&nbsp; 10.23<br>
total free extents 272425<br>
total free blocks 94291252<br>
  <br>
# xfs_db -r /dev/sdb1 -c 'freesp -s -a3'<br>
&nbsp;&nbsp; from&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; to extents&nbsp; blocks&nbsp;&nbsp;&nbsp; pct<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp;&nbsp; 5793&nbsp;&nbsp;&nbsp; 5793&nbsp;&nbsp; 0.01<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3&nbsp;&nbsp; 30667&nbsp;&nbsp; 70359&nbsp;&nbsp; 0.06<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 7&nbsp;&nbsp; 53174&nbsp; 301241&nbsp;&nbsp; 0.27<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 15&nbsp; 129098 1480652&nbsp;&nbsp; 1.34<br>
&nbsp;&nbsp;&nbsp;&nbsp; 16&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 31&nbsp;&nbsp;&nbsp; 4875&nbsp; 116797&nbsp;&nbsp; 0.11<br>
&nbsp;&nbsp;&nbsp;&nbsp; 32&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 63&nbsp;&nbsp;&nbsp;&nbsp; 148&nbsp;&nbsp;&nbsp; 6755&nbsp;&nbsp; 0.01<br>
&nbsp;&nbsp;&nbsp;&nbsp; 64&nbsp;&nbsp;&nbsp;&nbsp; 127&nbsp;&nbsp; 13192 1200672&nbsp;&nbsp; 1.09<br>
&nbsp;&nbsp;&nbsp; 128&nbsp;&nbsp;&nbsp;&nbsp; 255&nbsp;&nbsp;&nbsp; 1754&nbsp; 286342&nbsp;&nbsp; 0.26<br>
&nbsp;&nbsp;&nbsp; 256&nbsp;&nbsp;&nbsp;&nbsp; 511&nbsp;&nbsp; 35132 14122824&nbsp; 12.81<br>
&nbsp;&nbsp;&nbsp; 512&nbsp;&nbsp;&nbsp; 1023&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 6&nbsp;&nbsp;&nbsp; 4349&nbsp;&nbsp; 0.00<br>
&nbsp;&nbsp; 1024&nbsp;&nbsp;&nbsp; 2047&nbsp;&nbsp; 11609 18155617&nbsp; 16.47<br>
&nbsp;&nbsp; 2048&nbsp;&nbsp;&nbsp; 4095&nbsp;&nbsp;&nbsp;&nbsp; 447 1557312&nbsp;&nbsp; 1.41<br>
&nbsp;&nbsp; 4096&nbsp;&nbsp;&nbsp; 8191&nbsp;&nbsp;&nbsp;&nbsp; 342 2120360&nbsp;&nbsp; 1.92<br>
&nbsp;&nbsp; 8192&nbsp;&nbsp; 16383&nbsp;&nbsp;&nbsp;&nbsp; 147 1685429&nbsp;&nbsp; 1.53<br>
&nbsp; 16384&nbsp;&nbsp; 32767&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 21&nbsp; 438149&nbsp;&nbsp; 0.40<br>
&nbsp; 32768&nbsp;&nbsp; 65535&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 5&nbsp; 221907&nbsp;&nbsp; 0.20<br>
&nbsp; 65536&nbsp; 131071&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4&nbsp; 384869&nbsp;&nbsp; 0.35<br>
&nbsp;131072&nbsp; 262143&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3&nbsp; 576503&nbsp;&nbsp; 0.52<br>
&nbsp;524288 1048575&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp; 524974&nbsp;&nbsp; 0.48<br>
1048576 2097151&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2 2718327&nbsp;&nbsp; 2.47<br>
33554432 67108863&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1 64229173&nbsp; 58.28<br>
total free extents 286421<br>
total free blocks 110208404<br>
average free extent size 384.778<br>
  <br>
# xfs_db -r /dev/sdb1 -c 'freesp -s -a4'<br>
&nbsp;&nbsp; from&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; to extents&nbsp; blocks&nbsp;&nbsp;&nbsp; pct<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp;&nbsp; 5399&nbsp;&nbsp;&nbsp; 5399&nbsp;&nbsp; 0.01<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3&nbsp;&nbsp; 29098&nbsp;&nbsp; 67289&nbsp;&nbsp; 0.06<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 7&nbsp;&nbsp; 50889&nbsp; 287977&nbsp;&nbsp; 0.27<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 15&nbsp; 125018 1433485&nbsp;&nbsp; 1.34<br>
&nbsp;&nbsp;&nbsp;&nbsp; 16&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 31&nbsp;&nbsp;&nbsp; 4601&nbsp; 108565&nbsp;&nbsp; 0.10<br>
&nbsp;&nbsp;&nbsp;&nbsp; 32&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 63&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 86&nbsp;&nbsp;&nbsp; 3986&nbsp;&nbsp; 0.00<br>
&nbsp;&nbsp;&nbsp;&nbsp; 64&nbsp;&nbsp;&nbsp;&nbsp; 127&nbsp;&nbsp; 12587 1145709&nbsp;&nbsp; 1.07<br>
&nbsp;&nbsp;&nbsp; 128&nbsp;&nbsp;&nbsp;&nbsp; 255&nbsp;&nbsp;&nbsp; 1537&nbsp; 250472&nbsp;&nbsp; 0.23<br>
&nbsp;&nbsp;&nbsp; 256&nbsp;&nbsp;&nbsp;&nbsp; 511&nbsp;&nbsp; 35982 14464615&nbsp; 13.50<br>
&nbsp;&nbsp;&nbsp; 512&nbsp;&nbsp;&nbsp; 1023&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2&nbsp;&nbsp;&nbsp; 1039&nbsp;&nbsp; 0.00<br>
&nbsp;&nbsp; 1024&nbsp;&nbsp;&nbsp; 2047&nbsp;&nbsp; 11074 17306417&nbsp; 16.16<br>
&nbsp;&nbsp; 2048&nbsp;&nbsp;&nbsp; 4095&nbsp;&nbsp;&nbsp;&nbsp; 428 1488906&nbsp;&nbsp; 1.39<br>
&nbsp;&nbsp; 4096&nbsp;&nbsp;&nbsp; 8191&nbsp;&nbsp;&nbsp;&nbsp; 343 2130436&nbsp;&nbsp; 1.99<br>
&nbsp;&nbsp; 8192&nbsp;&nbsp; 16383&nbsp;&nbsp;&nbsp;&nbsp; 141 1574556&nbsp;&nbsp; 1.47<br>
&nbsp; 16384&nbsp;&nbsp; 32767&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 22&nbsp; 437491&nbsp;&nbsp; 0.41<br>
&nbsp; 32768&nbsp;&nbsp; 65535&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2&nbsp;&nbsp; 74530&nbsp;&nbsp; 0.07<br>
&nbsp; 65536&nbsp; 131071&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2&nbsp; 198418&nbsp;&nbsp; 0.19<br>
&nbsp;131072&nbsp; 262143&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2&nbsp; 399680&nbsp;&nbsp; 0.37<br>
&nbsp;262144&nbsp; 524287&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp; 278259&nbsp;&nbsp; 0.26<br>
&nbsp;524288 1048575&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp; 858623&nbsp;&nbsp; 0.80<br>
2097152 4194303&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1 2357798&nbsp;&nbsp; 2.20<br>
4194304 8388607&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1 7007241&nbsp;&nbsp; 6.54<br>
8388608 16777215&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2 24665312&nbsp; 23.03<br>
16777216 33554431&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1 30572144&nbsp; 28.54<br>
total free extents 277220<br>
total free blocks 107118347<br>
average free extent size 386.402<br>
  <br>
# xfs_db -r /dev/sdb1 -c 'freesp -s -a5'<br>
&nbsp;&nbsp; from&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; to extents&nbsp; blocks&nbsp;&nbsp;&nbsp; pct<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp;&nbsp; 5623&nbsp;&nbsp;&nbsp; 5623&nbsp;&nbsp; 0.01<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3&nbsp;&nbsp; 28053&nbsp;&nbsp; 65224&nbsp;&nbsp; 0.06<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 7&nbsp;&nbsp; 51000&nbsp; 288250&nbsp;&nbsp; 0.27<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 15&nbsp; 122593 1405739&nbsp;&nbsp; 1.32<br>
&nbsp;&nbsp;&nbsp;&nbsp; 16&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 31&nbsp;&nbsp;&nbsp; 4439&nbsp; 104165&nbsp;&nbsp; 0.10<br>
&nbsp;&nbsp;&nbsp;&nbsp; 32&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 63&nbsp;&nbsp;&nbsp;&nbsp; 107&nbsp;&nbsp;&nbsp; 4913&nbsp;&nbsp; 0.00<br>
&nbsp;&nbsp;&nbsp;&nbsp; 64&nbsp;&nbsp;&nbsp;&nbsp; 127&nbsp;&nbsp; 10904&nbsp; 992287&nbsp;&nbsp; 0.93<br>
&nbsp;&nbsp;&nbsp; 128&nbsp;&nbsp;&nbsp;&nbsp; 255&nbsp;&nbsp;&nbsp; 1458&nbsp; 237872&nbsp;&nbsp; 0.22<br>
&nbsp;&nbsp;&nbsp; 256&nbsp;&nbsp;&nbsp;&nbsp; 511&nbsp;&nbsp; 37480 15066766&nbsp; 14.19<br>
&nbsp;&nbsp;&nbsp; 512&nbsp;&nbsp;&nbsp; 1023&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4&nbsp;&nbsp;&nbsp; 3298&nbsp;&nbsp; 0.00<br>
&nbsp;&nbsp; 1024&nbsp;&nbsp;&nbsp; 2047&nbsp;&nbsp; 11035 17206454&nbsp; 16.20<br>
&nbsp;&nbsp; 2048&nbsp;&nbsp;&nbsp; 4095&nbsp;&nbsp;&nbsp;&nbsp; 416 1447533&nbsp;&nbsp; 1.36<br>
&nbsp;&nbsp; 4096&nbsp;&nbsp;&nbsp; 8191&nbsp;&nbsp;&nbsp;&nbsp; 367 2264983&nbsp;&nbsp; 2.13<br>
&nbsp;&nbsp; 8192&nbsp;&nbsp; 16383&nbsp;&nbsp;&nbsp;&nbsp; 132 1507258&nbsp;&nbsp; 1.42<br>
&nbsp; 16384&nbsp;&nbsp; 32767&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 17&nbsp; 369018&nbsp;&nbsp; 0.35<br>
&nbsp; 32768&nbsp;&nbsp; 65535&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 5&nbsp; 252737&nbsp;&nbsp; 0.24<br>
&nbsp; 65536&nbsp; 131071&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp; 93292&nbsp;&nbsp; 0.09<br>
&nbsp;131072&nbsp; 262143&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2&nbsp; 369218&nbsp;&nbsp; 0.35<br>
&nbsp;262144&nbsp; 524287&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp; 371390&nbsp;&nbsp; 0.35<br>
8388608 16777215&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1 11907027&nbsp; 11.21<br>
16777216 33554431&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1 17447945&nbsp; 16.43<br>
33554432 67108863&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1 34801264&nbsp; 32.77<br>
total free extents 273640<br>
total free blocks 106212256<br>
average free extent size 388.146<br>
  <br>
# xfs_db -r /dev/sdb1 -c 'freesp -s -a6'<br>
&nbsp;&nbsp; from&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; to extents&nbsp; blocks&nbsp;&nbsp;&nbsp; pct<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp;&nbsp; 5485&nbsp;&nbsp;&nbsp; 5485&nbsp;&nbsp; 0.01<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3&nbsp;&nbsp; 28092&nbsp;&nbsp; 65622&nbsp;&nbsp; 0.06<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 7&nbsp;&nbsp; 51124&nbsp; 288408&nbsp;&nbsp; 0.27<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 15&nbsp; 122946 1411945&nbsp;&nbsp; 1.32<br>
&nbsp;&nbsp;&nbsp;&nbsp; 16&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 31&nbsp;&nbsp;&nbsp; 4295&nbsp;&nbsp; 99036&nbsp;&nbsp; 0.09<br>
&nbsp;&nbsp;&nbsp;&nbsp; 32&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 63&nbsp;&nbsp;&nbsp;&nbsp; 136&nbsp;&nbsp;&nbsp; 6165&nbsp;&nbsp; 0.01<br>
&nbsp;&nbsp;&nbsp;&nbsp; 64&nbsp;&nbsp;&nbsp;&nbsp; 127&nbsp;&nbsp; 10723&nbsp; 975901&nbsp;&nbsp; 0.91<br>
&nbsp;&nbsp;&nbsp; 128&nbsp;&nbsp;&nbsp;&nbsp; 255&nbsp;&nbsp;&nbsp; 1393&nbsp; 227148&nbsp;&nbsp; 0.21<br>
&nbsp;&nbsp;&nbsp; 256&nbsp;&nbsp;&nbsp;&nbsp; 511&nbsp;&nbsp; 37816 15202240&nbsp; 14.21<br>
&nbsp;&nbsp;&nbsp; 512&nbsp;&nbsp;&nbsp; 1023&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 9&nbsp;&nbsp;&nbsp; 6955&nbsp;&nbsp; 0.01<br>
&nbsp;&nbsp; 1024&nbsp;&nbsp;&nbsp; 2047&nbsp;&nbsp; 11001 17139027&nbsp; 16.02<br>
&nbsp;&nbsp; 2048&nbsp;&nbsp;&nbsp; 4095&nbsp;&nbsp;&nbsp;&nbsp; 452 1570875&nbsp;&nbsp; 1.47<br>
&nbsp;&nbsp; 4096&nbsp;&nbsp;&nbsp; 8191&nbsp;&nbsp;&nbsp;&nbsp; 310 1937437&nbsp;&nbsp; 1.81<br>
&nbsp;&nbsp; 8192&nbsp;&nbsp; 16383&nbsp;&nbsp;&nbsp;&nbsp; 140 1622878&nbsp;&nbsp; 1.52<br>
&nbsp; 16384&nbsp;&nbsp; 32767&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 22&nbsp; 432606&nbsp;&nbsp; 0.40<br>
&nbsp; 32768&nbsp;&nbsp; 65535&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3&nbsp; 119928&nbsp;&nbsp; 0.11<br>
&nbsp; 65536&nbsp; 131071&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2&nbsp; 201539&nbsp;&nbsp; 0.19<br>
&nbsp;131072&nbsp; 262143&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp; 242792&nbsp;&nbsp; 0.23<br>
&nbsp;524288 1048575&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2 1642283&nbsp;&nbsp; 1.53<br>
1048576 2097151&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2 2522760&nbsp;&nbsp; 2.36<br>
4194304 8388607&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2 9405762&nbsp;&nbsp; 8.79<br>
16777216 33554431&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2 51878521&nbsp; 48.48<br>
total free extents 273958<br>
total free blocks 107005313<br>
average free extent size 390.59<br>
  <br>
# xfs_db -r /dev/sdb1 -c 'freesp -s -a7'<br>
&nbsp;&nbsp; from&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; to extents&nbsp; blocks&nbsp;&nbsp;&nbsp; pct<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp;&nbsp; 5728&nbsp;&nbsp;&nbsp; 5728&nbsp;&nbsp; 0.01<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3&nbsp;&nbsp; 27342&nbsp;&nbsp; 63963&nbsp;&nbsp; 0.06<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 7&nbsp;&nbsp; 51098&nbsp; 288588&nbsp;&nbsp; 0.27<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 15&nbsp; 122083 1400413&nbsp;&nbsp; 1.29<br>
&nbsp;&nbsp;&nbsp;&nbsp; 16&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 31&nbsp;&nbsp;&nbsp; 4154&nbsp;&nbsp; 95945&nbsp;&nbsp; 0.09<br>
&nbsp;&nbsp;&nbsp;&nbsp; 32&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 63&nbsp;&nbsp;&nbsp;&nbsp; 125&nbsp;&nbsp;&nbsp; 5696&nbsp;&nbsp; 0.01<br>
&nbsp;&nbsp;&nbsp;&nbsp; 64&nbsp;&nbsp;&nbsp;&nbsp; 127&nbsp;&nbsp; 10490&nbsp; 954737&nbsp;&nbsp; 0.88<br>
&nbsp;&nbsp;&nbsp; 128&nbsp;&nbsp;&nbsp;&nbsp; 255&nbsp;&nbsp;&nbsp; 1377&nbsp; 225554&nbsp;&nbsp; 0.21<br>
&nbsp;&nbsp;&nbsp; 256&nbsp;&nbsp;&nbsp;&nbsp; 511&nbsp;&nbsp; 38215 15362799&nbsp; 14.12<br>
&nbsp;&nbsp;&nbsp; 512&nbsp;&nbsp;&nbsp; 1023&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 5&nbsp;&nbsp;&nbsp; 3014&nbsp;&nbsp; 0.00<br>
&nbsp;&nbsp; 1024&nbsp;&nbsp;&nbsp; 2047&nbsp;&nbsp; 11138 17383490&nbsp; 15.98<br>
&nbsp;&nbsp; 2048&nbsp;&nbsp;&nbsp; 4095&nbsp;&nbsp;&nbsp;&nbsp; 446 1547400&nbsp;&nbsp; 1.42<br>
&nbsp;&nbsp; 4096&nbsp;&nbsp;&nbsp; 8191&nbsp;&nbsp;&nbsp;&nbsp; 314 1940099&nbsp;&nbsp; 1.78<br>
&nbsp;&nbsp; 8192&nbsp;&nbsp; 16383&nbsp;&nbsp;&nbsp;&nbsp; 138 1553781&nbsp;&nbsp; 1.43<br>
&nbsp; 16384&nbsp;&nbsp; 32767&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 26&nbsp; 526808&nbsp;&nbsp; 0.48<br>
&nbsp; 32768&nbsp;&nbsp; 65535&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 5&nbsp; 198738&nbsp;&nbsp; 0.18<br>
&nbsp; 65536&nbsp; 131071&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3&nbsp; 306072&nbsp;&nbsp; 0.28<br>
&nbsp;131072&nbsp; 262143&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp; 204457&nbsp;&nbsp; 0.19<br>
&nbsp;524288 1048575&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp; 675084&nbsp;&nbsp; 0.62<br>
4194304 8388607&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1 6256240&nbsp;&nbsp; 5.75<br>
8388608 16777215&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1 16700425&nbsp; 15.35<br>
16777216 33554431&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2 43106323&nbsp; 39.62<br>
total free extents 272693<br>
total free blocks 108805354<br>
average free extent size 399.003<br>
  <br>
# xfs_db -r /dev/sdb1 -c 'freesp -s -a8'<br>
&nbsp;&nbsp; from&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; to extents&nbsp; blocks&nbsp;&nbsp;&nbsp; pct<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp;&nbsp; 5545&nbsp;&nbsp;&nbsp; 5545&nbsp;&nbsp; 0.01<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3&nbsp;&nbsp; 27537&nbsp;&nbsp; 64379&nbsp;&nbsp; 0.06<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 7&nbsp;&nbsp; 50486&nbsp; 284834&nbsp;&nbsp; 0.28<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 15&nbsp; 121719 1398087&nbsp;&nbsp; 1.35<br>
&nbsp;&nbsp;&nbsp;&nbsp; 16&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 31&nbsp;&nbsp;&nbsp; 4169&nbsp;&nbsp; 96146&nbsp;&nbsp; 0.09<br>
&nbsp;&nbsp;&nbsp;&nbsp; 32&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 63&nbsp;&nbsp;&nbsp;&nbsp; 140&nbsp;&nbsp;&nbsp; 6404&nbsp;&nbsp; 0.01<br>
&nbsp;&nbsp;&nbsp;&nbsp; 64&nbsp;&nbsp;&nbsp;&nbsp; 127&nbsp;&nbsp; 10168&nbsp; 925246&nbsp;&nbsp; 0.90<br>
&nbsp;&nbsp;&nbsp; 128&nbsp;&nbsp;&nbsp;&nbsp; 255&nbsp;&nbsp;&nbsp; 1347&nbsp; 219934&nbsp;&nbsp; 0.21<br>
&nbsp;&nbsp;&nbsp; 256&nbsp;&nbsp;&nbsp;&nbsp; 511&nbsp;&nbsp; 38396 15435162&nbsp; 14.96<br>
&nbsp;&nbsp;&nbsp; 512&nbsp;&nbsp;&nbsp; 1023&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 9&nbsp;&nbsp;&nbsp; 6657&nbsp;&nbsp; 0.01<br>
&nbsp;&nbsp; 1024&nbsp;&nbsp;&nbsp; 2047&nbsp;&nbsp; 11038 17234155&nbsp; 16.70<br>
&nbsp;&nbsp; 2048&nbsp;&nbsp;&nbsp; 4095&nbsp;&nbsp;&nbsp;&nbsp; 411 1427988&nbsp;&nbsp; 1.38<br>
&nbsp;&nbsp; 4096&nbsp;&nbsp;&nbsp; 8191&nbsp;&nbsp;&nbsp;&nbsp; 337 2110360&nbsp;&nbsp; 2.04<br>
&nbsp;&nbsp; 8192&nbsp;&nbsp; 16383&nbsp;&nbsp;&nbsp;&nbsp; 134 1540661&nbsp;&nbsp; 1.49<br>
&nbsp; 16384&nbsp;&nbsp; 32767&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 29&nbsp; 608663&nbsp;&nbsp; 0.59<br>
&nbsp; 32768&nbsp;&nbsp; 65535&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4&nbsp; 194772&nbsp;&nbsp; 0.19<br>
&nbsp; 65536&nbsp; 131071&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp; 103722&nbsp;&nbsp; 0.10<br>
&nbsp;131072&nbsp; 262143&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp; 204540&nbsp;&nbsp; 0.20<br>
1048576 2097151&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1 1177573&nbsp;&nbsp; 1.14<br>
16777216 33554431&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1 19036961&nbsp; 18.45<br>
33554432 67108863&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1 41120777&nbsp; 39.84<br>
total free extents 271474<br>
total free blocks 103202566<br>
average free extent size 380.156<br>
  <br>
# xfs_db -r /dev/sdb1 -c 'freesp -s -a9'<br>
&nbsp;&nbsp; from&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; to extents&nbsp; blocks&nbsp;&nbsp;&nbsp; pct<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp;&nbsp; 5614&nbsp;&nbsp;&nbsp; 5614&nbsp;&nbsp; 0.01<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3&nbsp;&nbsp; 27343&nbsp;&nbsp; 63817&nbsp;&nbsp; 0.06<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 7&nbsp;&nbsp; 50789&nbsp; 286921&nbsp;&nbsp; 0.26<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 15&nbsp; 122085 1402116&nbsp;&nbsp; 1.28<br>
&nbsp;&nbsp;&nbsp;&nbsp; 16&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 31&nbsp;&nbsp;&nbsp; 4116&nbsp;&nbsp; 95310&nbsp;&nbsp; 0.09<br>
&nbsp;&nbsp;&nbsp;&nbsp; 32&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 63&nbsp;&nbsp;&nbsp;&nbsp; 152&nbsp;&nbsp;&nbsp; 6954&nbsp;&nbsp; 0.01<br>
&nbsp;&nbsp;&nbsp;&nbsp; 64&nbsp;&nbsp;&nbsp;&nbsp; 127&nbsp;&nbsp; 10679&nbsp; 971872&nbsp;&nbsp; 0.89<br>
&nbsp;&nbsp;&nbsp; 128&nbsp;&nbsp;&nbsp;&nbsp; 255&nbsp;&nbsp;&nbsp; 1315&nbsp; 215145&nbsp;&nbsp; 0.20<br>
&nbsp;&nbsp;&nbsp; 256&nbsp;&nbsp;&nbsp;&nbsp; 511&nbsp;&nbsp; 38557 15499672&nbsp; 14.19<br>
&nbsp;&nbsp;&nbsp; 512&nbsp;&nbsp;&nbsp; 1023&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 6&nbsp;&nbsp;&nbsp; 4435&nbsp;&nbsp; 0.00<br>
&nbsp;&nbsp; 1024&nbsp;&nbsp;&nbsp; 2047&nbsp;&nbsp; 11119 17330956&nbsp; 15.86<br>
&nbsp;&nbsp; 2048&nbsp;&nbsp;&nbsp; 4095&nbsp;&nbsp;&nbsp;&nbsp; 428 1485414&nbsp;&nbsp; 1.36<br>
&nbsp;&nbsp; 4096&nbsp;&nbsp;&nbsp; 8191&nbsp;&nbsp;&nbsp;&nbsp; 313 1932235&nbsp;&nbsp; 1.77<br>
&nbsp;&nbsp; 8192&nbsp;&nbsp; 16383&nbsp;&nbsp;&nbsp;&nbsp; 158 1823615&nbsp;&nbsp; 1.67<br>
&nbsp; 16384&nbsp;&nbsp; 32767&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 20&nbsp; 427607&nbsp;&nbsp; 0.39<br>
&nbsp; 32768&nbsp;&nbsp; 65535&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4&nbsp; 162954&nbsp;&nbsp; 0.15<br>
&nbsp; 65536&nbsp; 131071&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp; 74125&nbsp;&nbsp; 0.07<br>
&nbsp;262144&nbsp; 524287&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2&nbsp; 782823&nbsp;&nbsp; 0.72<br>
&nbsp;524288 1048575&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp; 979230&nbsp;&nbsp; 0.90<br>
4194304 8388607&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1 6064549&nbsp;&nbsp; 5.55<br>
33554432 67108863&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1 59625070&nbsp; 54.58<br>
total free extents 272704<br>
total free blocks 109240434<br>
average free extent size 400.582<br>
  <br>
# xfs_db -r /dev/sdb1 -c 'freesp -s -a10'<br>
&nbsp;&nbsp; from&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; to extents&nbsp; blocks&nbsp;&nbsp;&nbsp; pct<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp;&nbsp; 5451&nbsp;&nbsp;&nbsp; 5451&nbsp;&nbsp; 0.01<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3&nbsp;&nbsp; 27619&nbsp;&nbsp; 64469&nbsp;&nbsp; 0.06<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 7&nbsp;&nbsp; 50888&nbsp; 287306&nbsp;&nbsp; 0.27<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 15&nbsp; 122129 1401775&nbsp;&nbsp; 1.30<br>
&nbsp;&nbsp;&nbsp;&nbsp; 16&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 31&nbsp;&nbsp;&nbsp; 4156&nbsp;&nbsp; 96465&nbsp;&nbsp; 0.09<br>
&nbsp;&nbsp;&nbsp;&nbsp; 32&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 63&nbsp;&nbsp;&nbsp;&nbsp; 112&nbsp;&nbsp;&nbsp; 5115&nbsp;&nbsp; 0.00<br>
&nbsp;&nbsp;&nbsp;&nbsp; 64&nbsp;&nbsp;&nbsp;&nbsp; 127&nbsp;&nbsp; 10378&nbsp; 944415&nbsp;&nbsp; 0.87<br>
&nbsp;&nbsp;&nbsp; 128&nbsp;&nbsp;&nbsp;&nbsp; 255&nbsp;&nbsp;&nbsp; 1336&nbsp; 218180&nbsp;&nbsp; 0.20<br>
&nbsp;&nbsp;&nbsp; 256&nbsp;&nbsp;&nbsp;&nbsp; 511&nbsp;&nbsp; 38056 15298154&nbsp; 14.15<br>
&nbsp;&nbsp;&nbsp; 512&nbsp;&nbsp;&nbsp; 1023&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 6&nbsp;&nbsp;&nbsp; 3630&nbsp;&nbsp; 0.00<br>
&nbsp;&nbsp; 1024&nbsp;&nbsp;&nbsp; 2047&nbsp;&nbsp; 10908 17025890&nbsp; 15.75<br>
&nbsp;&nbsp; 2048&nbsp;&nbsp;&nbsp; 4095&nbsp;&nbsp;&nbsp;&nbsp; 443 1541035&nbsp;&nbsp; 1.43<br>
&nbsp;&nbsp; 4096&nbsp;&nbsp;&nbsp; 8191&nbsp;&nbsp;&nbsp;&nbsp; 326 2036141&nbsp;&nbsp; 1.88<br>
&nbsp;&nbsp; 8192&nbsp;&nbsp; 16383&nbsp;&nbsp;&nbsp;&nbsp; 150 1670607&nbsp;&nbsp; 1.55<br>
&nbsp; 16384&nbsp;&nbsp; 32767&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 23&nbsp; 497495&nbsp;&nbsp; 0.46<br>
&nbsp; 32768&nbsp;&nbsp; 65535&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 6&nbsp; 259503&nbsp;&nbsp; 0.24<br>
&nbsp; 65536&nbsp; 131071&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp; 80765&nbsp;&nbsp; 0.07<br>
&nbsp;131072&nbsp; 262143&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2&nbsp; 466041&nbsp;&nbsp; 0.43<br>
8388608 16777215&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2 24552174&nbsp; 22.72<br>
16777216 33554431&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2 41626231&nbsp; 38.51<br>
total free extents 271994<br>
total free blocks 108080842<br>
average free extent size 397.365<br>
  <br>
# xfs_db -r /dev/sdb1 -c 'freesp -s -a11'<br>
&nbsp;&nbsp; from&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; to extents&nbsp; blocks&nbsp;&nbsp;&nbsp; pct<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp;&nbsp; 5753&nbsp;&nbsp;&nbsp; 5753&nbsp;&nbsp; 0.01<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3&nbsp;&nbsp; 28506&nbsp;&nbsp; 66164&nbsp;&nbsp; 0.06<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 7&nbsp;&nbsp; 51222&nbsp; 289018&nbsp;&nbsp; 0.27<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 15&nbsp; 122115 1400237&nbsp;&nbsp; 1.31<br>
&nbsp;&nbsp;&nbsp;&nbsp; 16&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 31&nbsp;&nbsp;&nbsp; 4325&nbsp; 100622&nbsp;&nbsp; 0.09<br>
&nbsp;&nbsp;&nbsp;&nbsp; 32&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 63&nbsp;&nbsp;&nbsp;&nbsp; 121&nbsp;&nbsp;&nbsp; 5515&nbsp;&nbsp; 0.01<br>
&nbsp;&nbsp;&nbsp;&nbsp; 64&nbsp;&nbsp;&nbsp;&nbsp; 127&nbsp;&nbsp; 11218 1020941&nbsp;&nbsp; 0.95<br>
&nbsp;&nbsp;&nbsp; 128&nbsp;&nbsp;&nbsp;&nbsp; 255&nbsp;&nbsp;&nbsp; 1419&nbsp; 231469&nbsp;&nbsp; 0.22<br>
&nbsp;&nbsp;&nbsp; 256&nbsp;&nbsp;&nbsp;&nbsp; 511&nbsp;&nbsp; 37233 14967258&nbsp; 13.96<br>
&nbsp;&nbsp;&nbsp; 512&nbsp;&nbsp;&nbsp; 1023&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 13&nbsp;&nbsp; 10433&nbsp;&nbsp; 0.01<br>
&nbsp;&nbsp; 1024&nbsp;&nbsp;&nbsp; 2047&nbsp;&nbsp; 11040 17243570&nbsp; 16.08<br>
&nbsp;&nbsp; 2048&nbsp;&nbsp;&nbsp; 4095&nbsp;&nbsp;&nbsp;&nbsp; 438 1528105&nbsp;&nbsp; 1.42<br>
&nbsp;&nbsp; 4096&nbsp;&nbsp;&nbsp; 8191&nbsp;&nbsp;&nbsp;&nbsp; 313 1948122&nbsp;&nbsp; 1.82<br>
&nbsp;&nbsp; 8192&nbsp;&nbsp; 16383&nbsp;&nbsp;&nbsp;&nbsp; 137 1545209&nbsp;&nbsp; 1.44<br>
&nbsp; 16384&nbsp;&nbsp; 32767&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 17&nbsp; 340315&nbsp;&nbsp; 0.32<br>
&nbsp; 32768&nbsp;&nbsp; 65535&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3&nbsp; 135239&nbsp;&nbsp; 0.13<br>
&nbsp;524288 1048575&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp; 806510&nbsp;&nbsp; 0.75<br>
1048576 2097151&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1 1670160&nbsp;&nbsp; 1.56<br>
2097152 4194303&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1 3359120&nbsp;&nbsp; 3.13<br>
4194304 8388607&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1 4927086&nbsp;&nbsp; 4.59<br>
8388608 16777215&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2 26372734&nbsp; 24.59<br>
16777216 33554431&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1 29269614&nbsp; 27.29<br>
total free extents 273880<br>
total free blocks 107243194<br>
average free extent size 391.57<br>
  <br>
# xfs_db -r /dev/sdb1 -c 'freesp -s -a12'<br>
&nbsp;&nbsp; from&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; to extents&nbsp; blocks&nbsp;&nbsp;&nbsp; pct<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp;&nbsp; 5373&nbsp;&nbsp;&nbsp; 5373&nbsp;&nbsp; 0.01<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3&nbsp;&nbsp; 27530&nbsp;&nbsp; 64216&nbsp;&nbsp; 0.06<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 7&nbsp;&nbsp; 50788&nbsp; 286603&nbsp;&nbsp; 0.27<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 15&nbsp; 121652 1396720&nbsp;&nbsp; 1.31<br>
&nbsp;&nbsp;&nbsp;&nbsp; 16&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 31&nbsp;&nbsp;&nbsp; 4188&nbsp;&nbsp; 97008&nbsp;&nbsp; 0.09<br>
&nbsp;&nbsp;&nbsp;&nbsp; 32&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 63&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 71&nbsp;&nbsp;&nbsp; 3299&nbsp;&nbsp; 0.00<br>
&nbsp;&nbsp;&nbsp;&nbsp; 64&nbsp;&nbsp;&nbsp;&nbsp; 127&nbsp;&nbsp; 10446&nbsp; 950836&nbsp;&nbsp; 0.89<br>
&nbsp;&nbsp;&nbsp; 128&nbsp;&nbsp;&nbsp;&nbsp; 255&nbsp;&nbsp;&nbsp; 1349&nbsp; 220210&nbsp;&nbsp; 0.21<br>
&nbsp;&nbsp;&nbsp; 256&nbsp;&nbsp;&nbsp;&nbsp; 511&nbsp;&nbsp; 37835 15209592&nbsp; 14.28<br>
&nbsp;&nbsp;&nbsp; 512&nbsp;&nbsp;&nbsp; 1023&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp;&nbsp;&nbsp; 918&nbsp;&nbsp; 0.00<br>
&nbsp;&nbsp; 1024&nbsp;&nbsp;&nbsp; 2047&nbsp;&nbsp; 10950 17087135&nbsp; 16.04<br>
&nbsp;&nbsp; 2048&nbsp;&nbsp;&nbsp; 4095&nbsp;&nbsp;&nbsp;&nbsp; 416 1445170&nbsp;&nbsp; 1.36<br>
&nbsp;&nbsp; 4096&nbsp;&nbsp;&nbsp; 8191&nbsp;&nbsp;&nbsp;&nbsp; 341 2103801&nbsp;&nbsp; 1.98<br>
&nbsp;&nbsp; 8192&nbsp;&nbsp; 16383&nbsp;&nbsp;&nbsp;&nbsp; 146 1643458&nbsp;&nbsp; 1.54<br>
&nbsp; 16384&nbsp;&nbsp; 32767&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 27&nbsp; 551354&nbsp;&nbsp; 0.52<br>
&nbsp; 32768&nbsp;&nbsp; 65535&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 5&nbsp; 173876&nbsp;&nbsp; 0.16<br>
&nbsp; 65536&nbsp; 131071&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3&nbsp; 273193&nbsp;&nbsp; 0.26<br>
&nbsp;262144&nbsp; 524287&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2&nbsp; 695714&nbsp;&nbsp; 0.65<br>
&nbsp;524288 1048575&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2 1740580&nbsp;&nbsp; 1.63<br>
16777216 33554431&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1 22797321&nbsp; 21.40<br>
33554432 67108863&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1 39761770&nbsp; 37.33<br>
total free extents 271127<br>
total free blocks 106508147<br>
average free extent size 392.835<br>
  <br>
# xfs_db -r /dev/sdb1 -c 'freesp -s -a13'<br>
&nbsp;&nbsp; from&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; to extents&nbsp; blocks&nbsp;&nbsp;&nbsp; pct<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp;&nbsp; 5756&nbsp;&nbsp;&nbsp; 5756&nbsp;&nbsp; 0.01<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3&nbsp;&nbsp; 27074&nbsp;&nbsp; 63268&nbsp;&nbsp; 0.06<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 7&nbsp;&nbsp; 50796&nbsp; 287174&nbsp;&nbsp; 0.26<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 15&nbsp; 121675 1397015&nbsp;&nbsp; 1.28<br>
&nbsp;&nbsp;&nbsp;&nbsp; 16&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 31&nbsp;&nbsp;&nbsp; 4260&nbsp;&nbsp; 98417&nbsp;&nbsp; 0.09<br>
&nbsp;&nbsp;&nbsp;&nbsp; 32&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 63&nbsp;&nbsp;&nbsp;&nbsp; 136&nbsp;&nbsp;&nbsp; 6191&nbsp;&nbsp; 0.01<br>
&nbsp;&nbsp;&nbsp;&nbsp; 64&nbsp;&nbsp;&nbsp;&nbsp; 127&nbsp;&nbsp; 10324&nbsp; 939549&nbsp;&nbsp; 0.86<br>
&nbsp;&nbsp;&nbsp; 128&nbsp;&nbsp;&nbsp;&nbsp; 255&nbsp;&nbsp;&nbsp; 1315&nbsp; 215314&nbsp;&nbsp; 0.20<br>
&nbsp;&nbsp;&nbsp; 256&nbsp;&nbsp;&nbsp;&nbsp; 511&nbsp;&nbsp; 39195 15756002&nbsp; 14.40<br>
&nbsp;&nbsp;&nbsp; 512&nbsp;&nbsp;&nbsp; 1023&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 8&nbsp;&nbsp;&nbsp; 5675&nbsp;&nbsp; 0.01<br>
&nbsp;&nbsp; 1024&nbsp;&nbsp;&nbsp; 2047&nbsp;&nbsp; 11129 17335479&nbsp; 15.84<br>
&nbsp;&nbsp; 2048&nbsp;&nbsp;&nbsp; 4095&nbsp;&nbsp;&nbsp;&nbsp; 419 1457554&nbsp;&nbsp; 1.33<br>
&nbsp;&nbsp; 4096&nbsp;&nbsp;&nbsp; 8191&nbsp;&nbsp;&nbsp;&nbsp; 321 2012733&nbsp;&nbsp; 1.84<br>
&nbsp;&nbsp; 8192&nbsp;&nbsp; 16383&nbsp;&nbsp;&nbsp;&nbsp; 143 1666063&nbsp;&nbsp; 1.52<br>
&nbsp; 16384&nbsp;&nbsp; 32767&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 23&nbsp; 460740&nbsp;&nbsp; 0.42<br>
&nbsp; 32768&nbsp;&nbsp; 65535&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2&nbsp; 103286&nbsp;&nbsp; 0.09<br>
&nbsp; 65536&nbsp; 131071&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2&nbsp; 193585&nbsp;&nbsp; 0.18<br>
&nbsp;262144&nbsp; 524287&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp; 356370&nbsp;&nbsp; 0.33<br>
33554432 67108863&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1 67081225&nbsp; 61.29<br>
total free extents 272580<br>
total free blocks 109441396<br>
average free extent size 401.502<br>
  <br>
# xfs_db -r /dev/sdb1 -c 'freesp -s -a14'<br>
&nbsp;&nbsp; from&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; to extents&nbsp; blocks&nbsp;&nbsp;&nbsp; pct<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp;&nbsp; 5585&nbsp;&nbsp;&nbsp; 5585&nbsp;&nbsp; 0.01<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3&nbsp;&nbsp; 26740&nbsp;&nbsp; 62793&nbsp;&nbsp; 0.06<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 7&nbsp;&nbsp; 50781&nbsp; 286750&nbsp;&nbsp; 0.27<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 15&nbsp; 120804 1388061&nbsp;&nbsp; 1.30<br>
&nbsp;&nbsp;&nbsp;&nbsp; 16&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 31&nbsp;&nbsp;&nbsp; 4186&nbsp;&nbsp; 96930&nbsp;&nbsp; 0.09<br>
&nbsp;&nbsp;&nbsp;&nbsp; 32&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 63&nbsp;&nbsp;&nbsp;&nbsp; 160&nbsp;&nbsp;&nbsp; 7192&nbsp;&nbsp; 0.01<br>
&nbsp;&nbsp;&nbsp;&nbsp; 64&nbsp;&nbsp;&nbsp;&nbsp; 127&nbsp;&nbsp;&nbsp; 9898&nbsp; 900897&nbsp;&nbsp; 0.84<br>
&nbsp;&nbsp;&nbsp; 128&nbsp;&nbsp;&nbsp;&nbsp; 255&nbsp;&nbsp;&nbsp; 1318&nbsp; 215049&nbsp;&nbsp; 0.20<br>
&nbsp;&nbsp;&nbsp; 256&nbsp;&nbsp;&nbsp;&nbsp; 511&nbsp;&nbsp; 38427 15446911&nbsp; 14.48<br>
&nbsp;&nbsp;&nbsp; 512&nbsp;&nbsp;&nbsp; 1023&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 7&nbsp;&nbsp;&nbsp; 4130&nbsp;&nbsp; 0.00<br>
&nbsp;&nbsp; 1024&nbsp;&nbsp;&nbsp; 2047&nbsp;&nbsp; 11116 17330340&nbsp; 16.25<br>
&nbsp;&nbsp; 2048&nbsp;&nbsp;&nbsp; 4095&nbsp;&nbsp;&nbsp;&nbsp; 390 1356701&nbsp;&nbsp; 1.27<br>
&nbsp;&nbsp; 4096&nbsp;&nbsp;&nbsp; 8191&nbsp;&nbsp;&nbsp;&nbsp; 307 1917633&nbsp;&nbsp; 1.80<br>
&nbsp;&nbsp; 8192&nbsp;&nbsp; 16383&nbsp;&nbsp;&nbsp;&nbsp; 150 1679866&nbsp;&nbsp; 1.57<br>
&nbsp; 16384&nbsp;&nbsp; 32767&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 24&nbsp; 490742&nbsp;&nbsp; 0.46<br>
&nbsp; 32768&nbsp;&nbsp; 65535&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3&nbsp; 156921&nbsp;&nbsp; 0.15<br>
&nbsp; 65536&nbsp; 131071&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3&nbsp; 290496&nbsp;&nbsp; 0.27<br>
&nbsp;524288 1048575&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp; 715032&nbsp;&nbsp; 0.67<br>
1048576 2097151&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1 1570472&nbsp;&nbsp; 1.47<br>
33554432 67108863&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1 62750353&nbsp; 58.83<br>
total free extents 269902<br>
total free blocks 106672854<br>
average free extent size 395.228<br>
  <br>
# xfs_db -r /dev/sdb1 -c 'freesp -s -a15'<br>
&nbsp;&nbsp; from&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; to extents&nbsp; blocks&nbsp;&nbsp;&nbsp; pct<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp;&nbsp; 5734&nbsp;&nbsp;&nbsp; 5734&nbsp;&nbsp; 0.01<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3&nbsp;&nbsp; 15777&nbsp;&nbsp; 40616&nbsp;&nbsp; 0.05<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 7&nbsp;&nbsp; 51372&nbsp; 290289&nbsp;&nbsp; 0.39<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 15&nbsp; 121640 1396823&nbsp;&nbsp; 1.88<br>
&nbsp;&nbsp;&nbsp;&nbsp; 16&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 31&nbsp;&nbsp;&nbsp; 3105&nbsp;&nbsp; 69153&nbsp;&nbsp; 0.09<br>
&nbsp;&nbsp;&nbsp;&nbsp; 32&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 63&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 14&nbsp;&nbsp;&nbsp;&nbsp; 700&nbsp;&nbsp; 0.00<br>
&nbsp;&nbsp;&nbsp;&nbsp; 64&nbsp;&nbsp;&nbsp;&nbsp; 127&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 19&nbsp;&nbsp;&nbsp; 1760&nbsp;&nbsp; 0.00<br>
&nbsp;&nbsp;&nbsp; 128&nbsp;&nbsp;&nbsp;&nbsp; 255&nbsp;&nbsp;&nbsp; 3157&nbsp; 530350&nbsp;&nbsp; 0.71<br>
&nbsp;&nbsp;&nbsp; 256&nbsp;&nbsp;&nbsp;&nbsp; 511&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 18&nbsp;&nbsp;&nbsp; 7797&nbsp;&nbsp; 0.01<br>
&nbsp;&nbsp;&nbsp; 512&nbsp;&nbsp;&nbsp; 1023&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 7&nbsp;&nbsp;&nbsp; 4504&nbsp;&nbsp; 0.01<br>
&nbsp;&nbsp; 1024&nbsp;&nbsp;&nbsp; 2047&nbsp;&nbsp; 44155 71890115&nbsp; 96.61<br>
&nbsp;&nbsp; 2048&nbsp;&nbsp;&nbsp; 4095&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 5&nbsp;&nbsp; 13601&nbsp;&nbsp; 0.02<br>
&nbsp;&nbsp; 4096&nbsp;&nbsp;&nbsp; 8191&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4&nbsp;&nbsp; 20168&nbsp;&nbsp; 0.03<br>
&nbsp;&nbsp; 8192&nbsp;&nbsp; 16383&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3&nbsp;&nbsp; 24586&nbsp;&nbsp; 0.03<br>
&nbsp; 16384&nbsp;&nbsp; 32767&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4&nbsp;&nbsp; 80524&nbsp;&nbsp; 0.11<br>
&nbsp; 32768&nbsp;&nbsp; 65535&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp; 37430&nbsp;&nbsp; 0.05<br>
total free extents 245015<br>
total free blocks 74414150<br>
average free extent size 303.713<br>
  <br>
# xfs_db -r /dev/sdb1 -c 'freesp -s -a16'<br>
&nbsp;&nbsp; from&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; to extents&nbsp; blocks&nbsp;&nbsp;&nbsp; pct<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp;&nbsp; 5458&nbsp;&nbsp;&nbsp; 5458&nbsp;&nbsp; 0.01<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3&nbsp;&nbsp; 29896&nbsp;&nbsp; 69017&nbsp;&nbsp; 0.07<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 7&nbsp;&nbsp; 50646&nbsp; 286147&nbsp;&nbsp; 0.28<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 15&nbsp; 123250 1414603&nbsp;&nbsp; 1.37<br>
&nbsp;&nbsp;&nbsp;&nbsp; 16&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 31&nbsp;&nbsp;&nbsp; 4257&nbsp;&nbsp; 99155&nbsp;&nbsp; 0.10<br>
&nbsp;&nbsp;&nbsp;&nbsp; 32&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 63&nbsp;&nbsp;&nbsp;&nbsp; 112&nbsp;&nbsp;&nbsp; 5139&nbsp;&nbsp; 0.00<br>
&nbsp;&nbsp;&nbsp;&nbsp; 64&nbsp;&nbsp;&nbsp;&nbsp; 127&nbsp;&nbsp; 13228 1203844&nbsp;&nbsp; 1.17<br>
&nbsp;&nbsp;&nbsp; 128&nbsp;&nbsp;&nbsp;&nbsp; 255&nbsp;&nbsp;&nbsp; 1363&nbsp; 222544&nbsp;&nbsp; 0.22<br>
&nbsp;&nbsp;&nbsp; 256&nbsp;&nbsp;&nbsp;&nbsp; 511&nbsp;&nbsp; 31264 12567433&nbsp; 12.17<br>
&nbsp;&nbsp;&nbsp; 512&nbsp;&nbsp;&nbsp; 1023&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 8&nbsp;&nbsp;&nbsp; 5911&nbsp;&nbsp; 0.01<br>
&nbsp;&nbsp; 1024&nbsp;&nbsp;&nbsp; 2047&nbsp;&nbsp; 11091 17306832&nbsp; 16.76<br>
&nbsp;&nbsp; 2048&nbsp;&nbsp;&nbsp; 4095&nbsp;&nbsp;&nbsp;&nbsp; 452 1573760&nbsp;&nbsp; 1.52<br>
&nbsp;&nbsp; 4096&nbsp;&nbsp;&nbsp; 8191&nbsp;&nbsp;&nbsp;&nbsp; 356 2239416&nbsp;&nbsp; 2.17<br>
&nbsp;&nbsp; 8192&nbsp;&nbsp; 16383&nbsp;&nbsp;&nbsp;&nbsp; 135 1522673&nbsp;&nbsp; 1.47<br>
&nbsp; 16384&nbsp;&nbsp; 32767&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 17&nbsp; 350269&nbsp;&nbsp; 0.34<br>
&nbsp; 32768&nbsp;&nbsp; 65535&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3&nbsp; 122543&nbsp;&nbsp; 0.12<br>
&nbsp; 65536&nbsp; 131071&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3&nbsp; 374987&nbsp;&nbsp; 0.36<br>
&nbsp;131072&nbsp; 262143&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 5 1169749&nbsp;&nbsp; 1.13<br>
&nbsp;524288 1048575&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2 1884165&nbsp;&nbsp; 1.83<br>
1048576 2097151&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1 1237015&nbsp;&nbsp; 1.20<br>
8388608 16777215&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1 9194667&nbsp;&nbsp; 8.91<br>
16777216 33554431&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2 50384042&nbsp; 48.80<br>
total free extents 271550<br>
total free blocks 103239369<br>
average free extent size 380.185<br>
  <br>
# xfs_db -r /dev/sdb1 -c 'freesp -s -a17'<br>
&nbsp;&nbsp; from&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; to extents&nbsp; blocks&nbsp;&nbsp;&nbsp; pct<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp;&nbsp; 5788&nbsp;&nbsp;&nbsp; 5788&nbsp;&nbsp; 0.01<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3&nbsp;&nbsp; 26404&nbsp;&nbsp; 61921&nbsp;&nbsp; 0.06<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 7&nbsp;&nbsp; 50904&nbsp; 287563&nbsp;&nbsp; 0.27<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 15&nbsp; 120710 1385219&nbsp;&nbsp; 1.30<br>
&nbsp;&nbsp;&nbsp;&nbsp; 16&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 31&nbsp;&nbsp;&nbsp; 4204&nbsp;&nbsp; 97175&nbsp;&nbsp; 0.09<br>
&nbsp;&nbsp;&nbsp;&nbsp; 32&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 63&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 76&nbsp;&nbsp;&nbsp; 3490&nbsp;&nbsp; 0.00<br>
&nbsp;&nbsp;&nbsp;&nbsp; 64&nbsp;&nbsp;&nbsp;&nbsp; 127&nbsp;&nbsp; 10045&nbsp; 914186&nbsp;&nbsp; 0.86<br>
&nbsp;&nbsp;&nbsp; 128&nbsp;&nbsp;&nbsp;&nbsp; 255&nbsp;&nbsp;&nbsp; 1392&nbsp; 228552&nbsp;&nbsp; 0.21<br>
&nbsp;&nbsp;&nbsp; 256&nbsp;&nbsp;&nbsp;&nbsp; 511&nbsp;&nbsp; 36867 14820192&nbsp; 13.90<br>
&nbsp;&nbsp;&nbsp; 512&nbsp;&nbsp;&nbsp; 1023&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 7&nbsp;&nbsp;&nbsp; 4938&nbsp;&nbsp; 0.00<br>
&nbsp;&nbsp; 1024&nbsp;&nbsp;&nbsp; 2047&nbsp;&nbsp; 11286 17637792&nbsp; 16.54<br>
&nbsp;&nbsp; 2048&nbsp;&nbsp;&nbsp; 4095&nbsp;&nbsp;&nbsp;&nbsp; 441 1532071&nbsp;&nbsp; 1.44<br>
&nbsp;&nbsp; 4096&nbsp;&nbsp;&nbsp; 8191&nbsp;&nbsp;&nbsp;&nbsp; 334 2078958&nbsp;&nbsp; 1.95<br>
&nbsp;&nbsp; 8192&nbsp;&nbsp; 16383&nbsp;&nbsp;&nbsp;&nbsp; 123 1419610&nbsp;&nbsp; 1.33<br>
&nbsp; 16384&nbsp;&nbsp; 32767&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 19&nbsp; 396082&nbsp;&nbsp; 0.37<br>
&nbsp; 32768&nbsp;&nbsp; 65535&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 5&nbsp; 224967&nbsp;&nbsp; 0.21<br>
&nbsp; 65536&nbsp; 131071&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4&nbsp; 362807&nbsp;&nbsp; 0.34<br>
&nbsp;131072&nbsp; 262143&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp; 155224&nbsp;&nbsp; 0.15<br>
&nbsp;262144&nbsp; 524287&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2&nbsp; 866414&nbsp;&nbsp; 0.81<br>
&nbsp;524288 1048575&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp; 999449&nbsp;&nbsp; 0.94<br>
1048576 2097151&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1 1158766&nbsp;&nbsp; 1.09<br>
2097152 4194303&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1 2528878&nbsp;&nbsp; 2.37<br>
8388608 16777215&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3 39151859&nbsp; 36.72<br>
16777216 33554431&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1 20313097&nbsp; 19.05<br>
total free extents 268619<br>
total free blocks 106634998<br>
average free extent size 396.975<br>
  <br>
# xfs_db -r /dev/sdb1 -c 'freesp -s -a18'<br>
&nbsp;&nbsp; from&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; to extents&nbsp; blocks&nbsp;&nbsp;&nbsp; pct<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp;&nbsp; 5588&nbsp;&nbsp;&nbsp; 5588&nbsp;&nbsp; 0.03<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3&nbsp;&nbsp; 24900&nbsp;&nbsp; 58887&nbsp;&nbsp; 0.32<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 7&nbsp;&nbsp; 50929&nbsp; 287739&nbsp;&nbsp; 1.56<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 15&nbsp; 120592 1386142&nbsp;&nbsp; 7.52<br>
&nbsp;&nbsp;&nbsp;&nbsp; 16&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 31&nbsp;&nbsp;&nbsp; 4089&nbsp;&nbsp; 93924&nbsp;&nbsp; 0.51<br>
&nbsp;&nbsp;&nbsp;&nbsp; 32&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 63&nbsp;&nbsp;&nbsp;&nbsp; 141&nbsp;&nbsp;&nbsp; 6372&nbsp;&nbsp; 0.03<br>
&nbsp;&nbsp;&nbsp;&nbsp; 64&nbsp;&nbsp;&nbsp;&nbsp; 127&nbsp;&nbsp;&nbsp; 8468&nbsp; 770640&nbsp;&nbsp; 4.18<br>
&nbsp;&nbsp;&nbsp; 128&nbsp;&nbsp;&nbsp;&nbsp; 255&nbsp;&nbsp;&nbsp; 1339&nbsp; 218783&nbsp;&nbsp; 1.19<br>
&nbsp;&nbsp;&nbsp; 256&nbsp;&nbsp;&nbsp;&nbsp; 511&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 22&nbsp;&nbsp;&nbsp; 8582&nbsp;&nbsp; 0.05<br>
&nbsp;&nbsp;&nbsp; 512&nbsp;&nbsp;&nbsp; 1023&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4&nbsp;&nbsp;&nbsp; 2711&nbsp;&nbsp; 0.01<br>
&nbsp;&nbsp; 1024&nbsp;&nbsp;&nbsp; 2047&nbsp;&nbsp;&nbsp; 9719 15333235&nbsp; 83.15<br>
&nbsp;&nbsp; 2048&nbsp;&nbsp;&nbsp; 4095&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4&nbsp;&nbsp; 10960&nbsp;&nbsp; 0.06<br>
&nbsp;&nbsp; 4096&nbsp;&nbsp;&nbsp; 8191&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp;&nbsp; 4097&nbsp;&nbsp; 0.02<br>
&nbsp;&nbsp; 8192&nbsp;&nbsp; 16383&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp;&nbsp; 8769&nbsp;&nbsp; 0.05<br>
&nbsp; 16384&nbsp;&nbsp; 32767&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2&nbsp;&nbsp; 32791&nbsp;&nbsp; 0.18<br>
&nbsp; 32768&nbsp;&nbsp; 65535&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 5&nbsp; 210714&nbsp;&nbsp; 1.14<br>
total free extents 225804<br>
total free blocks 18439934<br>
average free extent size 81.6635<br>
  <br>
  </tt></blockquote>
<pre class="moz-signature" cols="72">Dave Hall
Binghamton University
<a class="moz-txt-link-abbreviated" href="mailto:kdhall@binghamton.edu">kdhall@binghamton.edu</a>
607-760-2328 (Cell)
607-777-4641 (Office)</pre>
<br>
On 03/30/2015 03:45 PM, Dave Chinner wrote:
<blockquote cite="mid:20150330194510.GD28621@dastard" type="cite">
  <pre wrap="">On Mon, Mar 30, 2015 at 02:19:59PM -0400, Dave Hall wrote:
  </pre>
  <blockquote type="cite">
    <pre wrap="">Hello,

I have an XFS file system that's getting 'No space left on device'
errors.  xfs_fsr also complains of 'No space left'.  The XFS Info
is:

   # xfs_info /data
   meta-data=/dev/sdb1              isize=256    agcount=19,
   agsize=268435440 blks
             =                       sectsz=512   attr=2
   data     =                       bsize=4096 blocks=4882431488, imaxpct=5
             =                       sunit=16     swidth=160 blks
   naming   =version 2              bsize=4096   ascii-ci=0
   log      =internal               bsize=4096   blocks=521728, version=2
             =                       sectsz=512   sunit=16 blks,
   lazy-count=1
   realtime =none                   extsz=4096   blocks=0, rtextents=0

   # df -h .
   Filesystem            Size  Used Avail Use% Mounted on
   /dev/sdb1              19T   12T  7.0T  62% /data
   # df -ih .
   Filesystem            Inodes   IUsed   IFree IUse% Mounted on
   /dev/sdb1               3.7G    4.7M    3.7G    1% /data


xfs_db freesp shows that AG 0 seems to be full.  I've included the
freesp for the first few AGs, but the rest seem pretty consistent
with AGs 1 - 4 that I've included below.

   xfs_db&gt; freesp -s -e 1000000000 -a 0
    </pre>
  </blockquote>
  <pre wrap="">
Can you please drop the "-e 1000000" from these commands and post it
again?  The histogram of differing free space sizes is information
we actually need to diagnose the problem...

Also, kernel version, mount options and machine details are
necessary to determine why AG0 might be full (e.g. allocation policy
in use).

Cheers,

Dave.
  </pre>
</blockquote>
</body>
</html>

--------------000606080309030203050905--


--===============2251610587146040100==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2251610587146040100==--
