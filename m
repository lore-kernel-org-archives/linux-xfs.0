Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C90187CA1
	for <xfs@oss.sgi.com>; Mon, 25 Jan 2016 10:38:13 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F189BAC008
	for <xfs@oss.sgi.com>; Mon, 25 Jan 2016 08:38:12 -0800 (PST)
Received: from mail-wm0-f43.google.com (mail-wm0-f43.google.com
	[74.125.82.43]) by cuda.sgi.com with ESMTP id 9hEBcIdn16NE0KqO
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 25 Jan 2016 08:38:08 -0800 (PST)
Received: by mail-wm0-f43.google.com with SMTP id l65so71429710wmf.1
	for <xfs@oss.sgi.com>; Mon, 25 Jan 2016 08:38:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160106234904.GL21461@dastard>
References: <CAC2B=ZGX2bkEhdgCrpS2X5v+SpAg0jtxZ19vk_9+O9aHME-FSA@mail.gmail.com>
	<20160106220454.GI21461@dastard> <20160106221004.GJ21461@dastard>
	<CAC2B=ZHe+crzN4vTjuNRRFgaxFHDDX2=Jn16EcwY1-ukt1=M6g@mail.gmail.com>
	<20160106234904.GL21461@dastard>
Date: Mon, 25 Jan 2016 11:38:07 -0500
Message-ID: <CAC2B=ZGktL2XnQEwmSpYxsosqZrvr_zNz_izBAqc+g5Ey4cH8Q@mail.gmail.com>
Subject: Re: xfs and swift
From: Mark Seger <mjseger@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7506839264880572252=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Laurence Oberman <loberman@redhat.com>, Linux fs XFS <xfs@oss.sgi.com>

--===============7506839264880572252==
Content-Type: multipart/alternative; boundary=047d7b5d457e95b6bc052a2b31af

--047d7b5d457e95b6bc052a2b31af
Content-Type: text/plain; charset=UTF-8

since getting your last reply I've been doing a lot more trying to
understand the behavior of what I'm seeing by writing some non-swift code
that sort of does what swift does with respect to a directory structure.
 in my case I have 1024 top level dirs, 4096 under each.  each 1k file I'm
creating gets it's only directory under these so there are clearly a lot of
directories.

xfs writes out about 25M objects and then the performance goes into the
toilet.  I'm sure what you said before about having to flush data and
causing big delays, but would it be continuous?  each entry in the
following table shows the time to write 10K files so the 2 blocks are 1M
each

Sat Jan 23 12:15:09 2016
 16.114386  14.656736  14.789760  17.418389  14.613157  15.938176
 14.865369  14.962058  17.297193  15.953590
 14.895471  15.560252  14.789937  14.308618  16.390057  16.561789
 15.713806  14.843791  15.940992  16.466924
 15.842781  15.611230  17.102329  15.006291  14.454088  17.923662
 13.378340  16.084664  15.996794  13.736398
 18.125125  14.462063  18.101833  15.355139  16.603660  14.205896
 16.474111  16.212237  15.072443  14.217581
 16.273899  14.905624  17.285019  14.955722  13.769731  18.308619
 15.601386  15.832661  14.342416  16.516657
 14.697575  15.719496  16.723135  16.808668  15.443325  14.608358
 17.031334  16.426377  13.900535  13.528603
 16.197697  16.839241  14.802707  15.507915  14.864337  15.836943
 15.660089  15.998911  13.956739  14.337318
 16.416974  17.729661  14.936045  13.450859  15.943900  15.106077
 15.541450  16.523752  16.555945  14.440305
 14.937772  16.486544  13.780310  16.944841  14.867400  18.214934
 14.142108  15.931952  14.424949  15.533156
 16.010153  16.323108  14.423508  15.970071  15.277186  15.561362
 14.978766  15.855935  16.953906  14.247016
Sat Jan 23 12:41:09 2016
 15.908483  15.638943  17.681281  15.188704  15.721495  13.359225
 15.999421  15.858876  16.402176  16.416312
 15.443946  14.675751  15.470643  15.573755  15.422241  16.336590
 17.220916  13.974890  15.877780  62.650921
 62.667990  46.334603  53.546195  69.465447  65.006016  68.761229
 70.754684  97.571669 104.811261 104.229302
105.605257 105.166030 105.058075 105.519703 106.573306 106.708545
106.114733 105.643131 106.049387 106.379378
104.239131 104.268931 103.852929 103.549319 103.516169 103.007015
103.724020 104.519983 105.839203 105.324985
104.328205 104.932713 103.051548 104.938652 102.769383 102.851609
101.432277 102.269842 100.937972 103.450103
103.477628 103.636130 103.444242 103.023145 102.565047 102.853115
101.402610  98.928230  99.310677  99.669667
101.140554  99.628664 102.093801 100.580659 101.762283 101.369349
102.637014 102.240950 101.778506 101.144526
100.899476 102.294952 102.029285 100.871166 102.763222 102.910690
104.892447 104.748194 105.403636 106.159345
106.413154 104.626632 105.775004 104.579775 104.778526 104.634778
106.233381 104.063642 106.635481 104.314503

if I look at the disk loads at the time, I see a dramatic increase in disk
reads that correspond to the slow writes so I'm guessing at least some
writes are waiting in the queue as you can see there - thanks to laurence
for the patch to show disk read wait times ;)

# DISK STATISTICS (/sec)
#
<---------reads---------------><---------writes--------------><--------averages-------->
Pct
#Time     Name       KBytes Merged  IOs Size  Wait  KBytes Merged  IOs Size
 Wait  RWSize  QLen  Wait SvcTim Util
12:45:30 sdb              0      0    0    0     0  270040    105 2276  119
    4     118    16     4      0   62
12:45:31 sdb              0      0    0    0     0  273776    120 2262  121
    4     121    18     4      0   57
12:45:32 sdb              4      0    1    4     0  100164     57  909  110
    4     110     6     4      0   84
12:45:33 sdb              0      0    0    0     0  229992     87 1924  120
    1     119     2     1      0   68
12:45:34 sdb              4      0    1    4     4  153528     59 1304  118
    0     117     1     0      0   78
12:45:35 sdb              0      0    0    0     0  220896     97 1895  117
    1     116     1     1      0   62
12:45:36 sdb              0      0    0    0     0  419084    197 3504  120
    0     119     1     0      0   32
12:45:37 sdb              0      0    0    0     0  428076    193 3662  117
    0     116     1     0      0   32
12:45:38 sdb              0      0    0    0     0  428492    181 3560  120
    0     120     1     0      0   30
12:45:39 sdb              0      0    0    0     0  426024    199 3641  117
    0     117     1     0      0   32
12:45:40 sdb              0      0    0    0     0  429764    200 3589  120
    0     119     1     0      0   28
12:45:41 sdb              0      0    0    0     0  410204    165 3430  120
    0     119     3     0      0   36
12:45:42 sdb              0      0    0    0     0  406192    196 3437  118
    0     118     5     0      0   39
12:45:43 sdb              0      0    0    0     0  420952    175 3552  119
    0     118     1     0      0   34
12:45:44 sdb              0      0    0    0     0  428424    197 3645  118
    0     117     1     0      0   31
12:45:45 sdb              0      0    0    0     0  192464     76 1599  120
    8     120    18     8      0   75
12:45:46 sdb              0      0    0    0     0  340522    205 2951  115
    2     115    16     2      0   41
12:45:47 sdb              0      0    0    0     0  429128    193 3664  117
    0     117     1     0      0   28
12:45:48 sdb              0      0    0    0     0  402600    164 3311  122
    0     121     3     0      0   39
12:45:49 sdb              0      0    0    0     0  435316    195 3701  118
    0     117     1     0      0   36
12:45:50 sdb              0      0    0    0     0  367976    162 3152  117
    1     116     7     1      0   46
12:45:51 sdb              0      0    0    0     0  255716    125 2153  119
    4     118    16     4      0   60

# DISK STATISTICS (/sec)
#
<---------reads---------------><---------writes--------------><--------averages-------->
Pct
#Time     Name       KBytes Merged  IOs Size  Wait  KBytes Merged  IOs Size
 Wait  RWSize  QLen  Wait SvcTim Util
12:45:52 sdb              0      0    0    0     0  360144    149 3006  120
    1     119     9     1      0   46
12:45:53 sdb              0      0    0    0     0  343500    162 2909  118
    1     118    11     1      0   43
12:45:54 sdb              0      0    0    0     0  256636    119 2188  117
    2     117    11     2      0   54
12:45:55 sdb              0      0    0    0     0  149000     47 1260  118
   14     118    22    14      0   79
12:45:56 sdb              0      0    0    0     0  198544     88 1654  120
    7     120    19     7      0   67
12:45:57 sdb              0      0    0    0     0  320688    151 2731  117
    1     117     8     1      0   53
12:45:58 sdb              0      0    0    0     0  422176    190 3532  120
    0     119     1     0      0   32
12:45:59 sdb              0      0    0    0     0  266540    115 2233  119
    5     119    13     5      0   93
12:46:00 sdb              8      0    2    4   690  291116    129 2463  118
    3     118     9     3      0   82
12:46:01 sdb              0      0    0    0     0  249964    118 2160  116
    4     115    15     4      0   60
12:46:02 sdb           4736      0   37  128     0  424680    167 3522  121
    0     120     1     0      0   28
12:46:03 sdb           5016      0   42  119     0  391364    196 3344  117
    0     117     6     0      0   34
12:46:04 sdb              0      0    0    0     0  415436    172 3501  119
    0     118     2     0      0   33
12:46:05 sdb              0      0    0    0     0  398736    192 3373  118
    0     118     3     0      0   39
12:46:06 sdb              0      0    0    0     0  367292    155 3015  122
    0     121     6     0      0   39
12:46:07 sdb              0      0    0    0     0  420392    201 3614  116
    0     116     1     0      0   30
12:46:08 sdb              0      0    0    0     0  424828    172 3547  120
    0     119     1     0      0   32
12:46:09 sdb              0      0    0    0     0  500380    234 4277  117
    0     116     2     0      0   34
12:46:10 sdb              0      0    0    0     0  104500      7  698  150
    0     149     1     0      1   87
12:46:11 sdb              8      0    1    8  1260   77252     45  647  119
    0     119     1     2      1   92
12:46:12 sdb              8      0    1    8  1244   73956     31  615  120
    0     120     1     2      1   94
12:46:13 sdb              8      0    1    8   228  149552     64 1256  119
    0     118     1     0      0   85

# DISK STATISTICS (/sec)
#
<---------reads---------------><---------writes--------------><--------averages-------->
Pct
#Time     Name       KBytes Merged  IOs Size  Wait  KBytes Merged  IOs Size
 Wait  RWSize  QLen  Wait SvcTim Util
12:46:14 sdb              8      0    1    8  1232   37124     28  319  116
    0     116     1     3      3   99
12:46:15 sdb             16      0    2    8   720    2776     23  120   23
    1      22     1    13      8   99
12:46:16 sdb              0      0    0    0     0  108180     16  823  131
    0     131     1     0      1   90
12:46:17 sdb              8      0    1    8  1260   37136     28  322  115
    0     114     1     3      2   94
12:46:18 sdb              8      0    1    8  1252  108680     57  875  124
    0     124     1     1      1   88
12:46:19 sdb              0      0    0    0     0       0      0    0    0
    0       0     1     0      0  100
12:46:20 sdb             16      0    2    8   618   81516     49  685  119
    0     118     1     1      1   94
12:46:21 sdb             16      0    2    8   640  225788    106 1907  118
    0     118     1     0      0   75
12:46:22 sdb             32      0    4    8    95   73892     17  627  118
    0     117     1     0      1   93
12:46:23 sdb             24      0    3    8   408  257012    119 2171  118
    0     118     1     0      0   65
12:46:24 sdb             12      0    3    4     5    3608      0   20  180
    0     157     1     0     43  100
12:46:25 sdb             44      0    7    6   210   74072     41  625  119
    0     117     1     2      1   97
12:46:26 sdb             48      0    6    8   216  202852    112 1819  112
    0     111     1     0      0   92
12:46:27 sdb             52      0    7    7   233  307156    137 2648  116
    0     115     1     0      0   95
12:46:28 sdb             16      0    2    8   100   93168      7  638  146
    0     145     1     0      1   97
12:46:29 sdb             16      0    2    8   642   37028     16  319  116
    0     115     1     4      3   99
12:46:30 sdb             16      0    2    8   624   39068     36  342  114
    0     113     1     3      2   99
12:46:31 sdb             80      0   10    8    94  253892    105 2169  117
    0     116     1     0      0   84
12:46:32 sdb              0      0    0    0     0    5676      0   33  172
    0     172     1     0     30  100
12:46:33 sdb             16      0    2    8   642   69236     28  583  119
    0     118     1     2      1   96
12:46:34 sdb              8      0    1    8  1032   37132     30  315  118
    0     117     1     3      3  100
12:46:35 sdb             16      0    2    8   822   56292     15  515  109
    0     108     1     3      1  100

# DISK STATISTICS (/sec)
#
<---------reads---------------><---------writes--------------><--------averages-------->
Pct
#Time     Name       KBytes Merged  IOs Size  Wait  KBytes Merged  IOs Size
 Wait  RWSize  QLen  Wait SvcTim Util
12:46:36 sdb              8      0    1    8    44   58768     15  452  130
    0     129     1     0      2   96
12:46:37 sdb             28      0    4    7   390  114944     89 1100  104
    0     104     1     1      0   88
12:46:38 sdb              0      0    0    0     0   29668      0  172  172
   12     172     1    12      5   98
12:46:39 sdb             80      0   10    8    90  100084     31  882  113
    0     112     1     1      1   91
12:46:40 sdb              0      0    0    0     0   24244      0  139  174
    0     174     1     0      7  100
12:46:41 sdb              8      0    1    8  1224       0      0    0    0
    0       8     1  1224   1000  100
12:46:42 sdb              8      0    1    8  1244   42368     29  354  120
    0     119     1     3      2   96
12:46:43 sdb             36      0    5    7   251   51428     32  507  101
    0     100     1     2      1   94
12:46:44 sdb             24      0    3    8    70    5732     31  147   39
   15      38     2    16      6   99
12:46:45 sdb             32      0    4    8     4  213056     53 1647  129
    0     129     1     0      0   74
12:46:46 sdb              8      0    1    8  1220   37416     28  328  114
    0     113     1     3      2   96
12:46:47 sdb              8      0    1    8  1248   58572     67  607   96
    0      96     1     2      1   93
12:46:48 sdb             40      0    5    8    84  274808     82 2173  126
    0     126     1     0      0   70
12:46:49 sdb              0      0    0    0     0       0      0    0    0
    0       0     1     0      0  100
12:46:50 sdb              8      0    1    8  1248       0      0    0    0
    0       8     1  1248   1000  100
12:46:51 sdb              8      0    1    8  1272       0      0    0    0
    0       8     1  1272   1000  100
12:46:52 sdb             24      0    3    8   414  205240    113 1798  114
    0     113     1     0      0   75
12:46:53 sdb              8      0    1    8   876   92476     48  839  110
    0     110     1     1      1   89
12:46:54 sdb              0      0    0    0     0   38700      0  225  172
    0     172     1     0      4   99
12:46:55 sdb             16      0    2    8   582  150680     73 1262  119
    0     119     1     1      0   87
12:46:56 sdb              8      0    1    8  1228       0      0    0    0
    0       8     1  1228   1000  100
12:46:57 sdb              8      0    1    8  1244       0      0    0    0
    0       8     1  1244   1000  100

next I played back the collectl process data and sorted by disk reads and
discovered the top process, corresponding to the long disk reads was
xfsaild.  btw - I also see the slab xfs_inode using about 60GB.

It's also worth noting that I'm only doing 1-2MB/sec of writes and the rest
of the data looks like it's coming from xfs journaling because when I look
at the xfs stats I'm seeing on the order of 200-400MB/sec xfs logging
writes - clearly they're not all going to disk.  Once the read waits
increase everything slows down including xfs logging (since it's doing
less).

I'm sure the simple answer may be that it is what it is, but I'm also
wondering without changes to swift itself, might there be some ways to
improve the situation by adding more memory or making any other tuning
changes?  The system I'm currently running my tests on has 128GB.

-mark

On Wed, Jan 6, 2016 at 6:49 PM, Dave Chinner <david@fromorbit.com> wrote:

> On Wed, Jan 06, 2016 at 05:46:33PM -0500, Mark Seger wrote:
> > dave, thanks for getting back to me and the pointer to the config doc.
> >  lots to absorb and play with.
> >
> > the real challenge for me is that I'm doing testing as different levels.
> > While i realize running 100 parallel swift PUT threads on a small system
> is
> > not the ideal way to do things, it's the only easy way to get massive
> > numbers of objects into the fillesystem and once there, the performance
> of
> > a single stream is pretty poor and by instrumenting the swift code I can
> > clearly see excess time being spent in creating/writing the objects and
> so
> > that's lead us to believe the problem lies in the way xfs is configured.
> >  creating a new directory structure on that same mount point immediately
> > results in high levels of performance.
> >
> > As an attempt to try to reproduce the problems w/o swift, I wrote a
> little
> > python script that simply creates files in a 2-tier structure, the first
> > tier consisting of 1024 directories and each directory contains 4096
> > subdirectories into which 1K files are created.
>
> So you created something with even greater fan-out than what your
> swift app is using?
>
> > I'm doing this for 10000
> > objects as a time and then timing them, reporting the times, 10 per line
> so
> > each line represents 100 thousand file creates.
> >
> > Here too I'm seeing degradation and if I look at what happens when there
> > are already 3M files and I write 1M more, I see these creation times/10
> > thousand:
> >
> >  1.004236  0.961419  0.996514  1.012150  1.101794  0.999422  0.994796
> >  1.214535  0.997276  1.306736
> >  2.793429  1.201471  1.133576  1.069682  1.030985  1.096341  1.052602
> >  1.391364  0.999480  1.914125
> >  1.193892  0.967206  1.263310  0.890472  1.051962  4.253694  1.145573
> >  1.528848 13.586892  4.925790
> >  3.975442  8.896552  1.197005  3.904226  7.503806  1.294842  1.816422
> >  9.329792  7.270323  5.936545
> >  7.058685  5.516841  4.527271  1.956592  1.382551  1.510339  1.318341
> > 13.255939  6.938845  4.106066
> >  2.612064  2.028795  4.647980  7.371628  5.473423  5.823201 14.229120
> >  0.899348  3.539658  8.501498
> >  4.662593  6.423530  7.980757  6.367012  3.414239  7.364857  4.143751
> >  6.317348 11.393067  1.273371
> > 146.067300  1.317814  1.176529  1.177830 52.206605  1.112854  2.087990
> > 42.328220  1.178436  1.335202
> > 49.118140  1.368696  1.515826 44.690431  0.927428  0.920801  0.985965
> >  1.000591  1.027458 60.650443
> >  1.771318  2.690499  2.262868  1.061343  0.932998 64.064210 37.726213
> >  1.245129  0.743771  0.996683
> >
> > nothing one set of 10K took almost 3 minutes!
>
> Which is no surprise because you have slow disks and a *lot* of
> memory. At some point the journal and/or memory is going to fill up
> with dirty objects and have to block waiting for writeback. At that
> point there's going to be several hundred thousand dirty inodes that
> need to be flushed to disk before progress can be made again.  That
> metadata writeback will be seek bound, and that's where all the
> delay comes from.
>
> We've been through this problem several times now with different
> swift users over the past couple of years. Please go and search the
> list archives, because every time the solution has been the same:
>
>         - reduce the directory heirarchy to a single level with, at
>           most, the number of directories matching the expected
>           *production* concurrency level
>         - reduce the XFS log size down to 32-128MB to limit dirty
>           metadata object buildup in memory
>         - reduce the number of AGs to as small as necessary to
>           maintain /allocation/ concurrency to limit the number of
>           different locations XFS writes to the disks (typically
>           10-20x less than the application level concurrency)
>         - use a 3.16+ kernel with the free inode btree on-disk
>           format feature to keep inode allocation CPU overhead low
>           and consistent regardless of the number of inodes already
>           allocated in the filesystem.
>
> > my main questions at this point are is this performance expected and/or
> > might a newer kernel help?  and might it be possible to significantly
> > improve things via tuning or is it what it is?  I do realize I'm starting
> > with an empty directory tree whose performance degrades as it fills, but
> if
> > I wanted to tune for say 10M or maybe 100M files might I be able to
> expect
>
> The mkfs defaults will work just fine with that many files in the
> filesystem. Your application configuration and data store layout is
> likely to be your biggest problem here.
>
> Cheers,
>
> Dave.
>
> --
> Dave Chinner
> david@fromorbit.com
>

--047d7b5d457e95b6bc052a2b31af
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: base64

PGRpdiBkaXI9Imx0ciI+c2luY2UgZ2V0dGluZyB5b3VyIGxhc3QgcmVwbHkgSSYjMzk7dmUgYmVl
biBkb2luZyBhIGxvdCBtb3JlIHRyeWluZyB0byB1bmRlcnN0YW5kIHRoZSBiZWhhdmlvciBvZiB3
aGF0IEkmIzM5O20gc2VlaW5nIGJ5IHdyaXRpbmcgc29tZSBub24tc3dpZnQgY29kZSB0aGF0IHNv
cnQgb2YgZG9lcyB3aGF0IHN3aWZ0IGRvZXMgd2l0aCByZXNwZWN0IHRvIGEgZGlyZWN0b3J5IHN0
cnVjdHVyZS4gwqBpbiBteSBjYXNlIEkgaGF2ZSAxMDI0IHRvcCBsZXZlbCBkaXJzLCA0MDk2IHVu
ZGVyIGVhY2guIMKgZWFjaCAxayBmaWxlIEkmIzM5O20gY3JlYXRpbmcgZ2V0cyBpdCYjMzk7cyBv
bmx5IGRpcmVjdG9yeSB1bmRlciB0aGVzZSBzbyB0aGVyZSBhcmUgY2xlYXJseSBhIGxvdCBvZiBk
aXJlY3Rvcmllcy48ZGl2Pjxicj48L2Rpdj48ZGl2PnhmcyB3cml0ZXMgb3V0IGFib3V0IDI1TSBv
YmplY3RzIGFuZCB0aGVuIHRoZSBwZXJmb3JtYW5jZSBnb2VzIGludG8gdGhlIHRvaWxldC7CoCBJ
JiMzOTttIHN1cmUgd2hhdCB5b3Ugc2FpZCBiZWZvcmUgYWJvdXQgaGF2aW5nIHRvIGZsdXNoIGRh
dGEgYW5kIGNhdXNpbmcgYmlnIGRlbGF5cywgYnV0IHdvdWxkIGl0IGJlIGNvbnRpbnVvdXM/IMKg
ZWFjaCBlbnRyeSBpbiB0aGUgZm9sbG93aW5nIHRhYmxlIHNob3dzIHRoZSB0aW1lIHRvIHdyaXRl
IDEwSyBmaWxlcyBzbyB0aGUgMiBibG9ja3MgYXJlIDFNIGVhY2g8L2Rpdj48ZGl2Pjxicj48L2Rp
dj48ZGl2PjxkaXY+U2F0IEphbiAyMyAxMjoxNTowOSAyMDE2PC9kaXY+PGRpdj7CoDE2LjExNDM4
NiDCoDE0LjY1NjczNiDCoDE0Ljc4OTc2MCDCoDE3LjQxODM4OSDCoDE0LjYxMzE1NyDCoDE1Ljkz
ODE3NiDCoDE0Ljg2NTM2OSDCoDE0Ljk2MjA1OCDCoDE3LjI5NzE5MyDCoDE1Ljk1MzU5MDwvZGl2
PjxkaXY+wqAxNC44OTU0NzEgwqAxNS41NjAyNTIgwqAxNC43ODk5MzcgwqAxNC4zMDg2MTggwqAx
Ni4zOTAwNTcgwqAxNi41NjE3ODkgwqAxNS43MTM4MDYgwqAxNC44NDM3OTEgwqAxNS45NDA5OTIg
wqAxNi40NjY5MjQ8L2Rpdj48ZGl2PsKgMTUuODQyNzgxIMKgMTUuNjExMjMwIMKgMTcuMTAyMzI5
IMKgMTUuMDA2MjkxIMKgMTQuNDU0MDg4IMKgMTcuOTIzNjYyIMKgMTMuMzc4MzQwIMKgMTYuMDg0
NjY0IMKgMTUuOTk2Nzk0IMKgMTMuNzM2Mzk4PC9kaXY+PGRpdj7CoDE4LjEyNTEyNSDCoDE0LjQ2
MjA2MyDCoDE4LjEwMTgzMyDCoDE1LjM1NTEzOSDCoDE2LjYwMzY2MCDCoDE0LjIwNTg5NiDCoDE2
LjQ3NDExMSDCoDE2LjIxMjIzNyDCoDE1LjA3MjQ0MyDCoDE0LjIxNzU4MTwvZGl2PjxkaXY+wqAx
Ni4yNzM4OTkgwqAxNC45MDU2MjQgwqAxNy4yODUwMTkgwqAxNC45NTU3MjIgwqAxMy43Njk3MzEg
wqAxOC4zMDg2MTkgwqAxNS42MDEzODYgwqAxNS44MzI2NjEgwqAxNC4zNDI0MTYgwqAxNi41MTY2
NTc8L2Rpdj48ZGl2PsKgMTQuNjk3NTc1IMKgMTUuNzE5NDk2IMKgMTYuNzIzMTM1IMKgMTYuODA4
NjY4IMKgMTUuNDQzMzI1IMKgMTQuNjA4MzU4IMKgMTcuMDMxMzM0IMKgMTYuNDI2Mzc3IMKgMTMu
OTAwNTM1IMKgMTMuNTI4NjAzPC9kaXY+PGRpdj7CoDE2LjE5NzY5NyDCoDE2LjgzOTI0MSDCoDE0
LjgwMjcwNyDCoDE1LjUwNzkxNSDCoDE0Ljg2NDMzNyDCoDE1LjgzNjk0MyDCoDE1LjY2MDA4OSDC
oDE1Ljk5ODkxMSDCoDEzLjk1NjczOSDCoDE0LjMzNzMxODwvZGl2PjxkaXY+wqAxNi40MTY5NzQg
wqAxNy43Mjk2NjEgwqAxNC45MzYwNDUgwqAxMy40NTA4NTkgwqAxNS45NDM5MDAgwqAxNS4xMDYw
NzcgwqAxNS41NDE0NTAgwqAxNi41MjM3NTIgwqAxNi41NTU5NDUgwqAxNC40NDAzMDU8L2Rpdj48
ZGl2PsKgMTQuOTM3NzcyIMKgMTYuNDg2NTQ0IMKgMTMuNzgwMzEwIMKgMTYuOTQ0ODQxIMKgMTQu
ODY3NDAwIMKgMTguMjE0OTM0IMKgMTQuMTQyMTA4IMKgMTUuOTMxOTUyIMKgMTQuNDI0OTQ5IMKg
MTUuNTMzMTU2PC9kaXY+PGRpdj7CoDE2LjAxMDE1MyDCoDE2LjMyMzEwOCDCoDE0LjQyMzUwOCDC
oDE1Ljk3MDA3MSDCoDE1LjI3NzE4NiDCoDE1LjU2MTM2MiDCoDE0Ljk3ODc2NiDCoDE1Ljg1NTkz
NSDCoDE2Ljk1MzkwNiDCoDE0LjI0NzAxNjwvZGl2PjxkaXY+U2F0IEphbiAyMyAxMjo0MTowOSAy
MDE2PC9kaXY+PGRpdj7CoDE1LjkwODQ4MyDCoDE1LjYzODk0MyDCoDE3LjY4MTI4MSDCoDE1LjE4
ODcwNCDCoDE1LjcyMTQ5NSDCoDEzLjM1OTIyNSDCoDE1Ljk5OTQyMSDCoDE1Ljg1ODg3NiDCoDE2
LjQwMjE3NiDCoDE2LjQxNjMxMjwvZGl2PjxkaXY+wqAxNS40NDM5NDYgwqAxNC42NzU3NTEgwqAx
NS40NzA2NDMgwqAxNS41NzM3NTUgwqAxNS40MjIyNDEgwqAxNi4zMzY1OTAgwqAxNy4yMjA5MTYg
wqAxMy45NzQ4OTAgwqAxNS44Nzc3ODAgwqA2Mi42NTA5MjE8L2Rpdj48ZGl2PsKgNjIuNjY3OTkw
IMKgNDYuMzM0NjAzIMKgNTMuNTQ2MTk1IMKgNjkuNDY1NDQ3IMKgNjUuMDA2MDE2IMKgNjguNzYx
MjI5IMKgNzAuNzU0Njg0IMKgOTcuNTcxNjY5IDEwNC44MTEyNjEgMTA0LjIyOTMwMjwvZGl2Pjxk
aXY+MTA1LjYwNTI1NyAxMDUuMTY2MDMwIDEwNS4wNTgwNzUgMTA1LjUxOTcwMyAxMDYuNTczMzA2
IDEwNi43MDg1NDUgMTA2LjExNDczMyAxMDUuNjQzMTMxIDEwNi4wNDkzODcgMTA2LjM3OTM3ODwv
ZGl2PjxkaXY+MTA0LjIzOTEzMSAxMDQuMjY4OTMxIDEwMy44NTI5MjkgMTAzLjU0OTMxOSAxMDMu
NTE2MTY5IDEwMy4wMDcwMTUgMTAzLjcyNDAyMCAxMDQuNTE5OTgzIDEwNS44MzkyMDMgMTA1LjMy
NDk4NTwvZGl2PjxkaXY+MTA0LjMyODIwNSAxMDQuOTMyNzEzIDEwMy4wNTE1NDggMTA0LjkzODY1
MiAxMDIuNzY5MzgzIDEwMi44NTE2MDkgMTAxLjQzMjI3NyAxMDIuMjY5ODQyIDEwMC45Mzc5NzIg
MTAzLjQ1MDEwMzwvZGl2PjxkaXY+MTAzLjQ3NzYyOCAxMDMuNjM2MTMwIDEwMy40NDQyNDIgMTAz
LjAyMzE0NSAxMDIuNTY1MDQ3IDEwMi44NTMxMTUgMTAxLjQwMjYxMCDCoDk4LjkyODIzMCDCoDk5
LjMxMDY3NyDCoDk5LjY2OTY2NzwvZGl2PjxkaXY+MTAxLjE0MDU1NCDCoDk5LjYyODY2NCAxMDIu
MDkzODAxIDEwMC41ODA2NTkgMTAxLjc2MjI4MyAxMDEuMzY5MzQ5IDEwMi42MzcwMTQgMTAyLjI0
MDk1MCAxMDEuNzc4NTA2IDEwMS4xNDQ1MjY8L2Rpdj48ZGl2PjEwMC44OTk0NzYgMTAyLjI5NDk1
MiAxMDIuMDI5Mjg1IDEwMC44NzExNjYgMTAyLjc2MzIyMiAxMDIuOTEwNjkwIDEwNC44OTI0NDcg
MTA0Ljc0ODE5NCAxMDUuNDAzNjM2IDEwNi4xNTkzNDU8L2Rpdj48L2Rpdj48ZGl2PjxkaXY+MTA2
LjQxMzE1NCAxMDQuNjI2NjMyIDEwNS43NzUwMDQgMTA0LjU3OTc3NSAxMDQuNzc4NTI2IDEwNC42
MzQ3NzggMTA2LjIzMzM4MSAxMDQuMDYzNjQyIDEwNi42MzU0ODEgMTA0LjMxNDUwMzwvZGl2Pjwv
ZGl2PjxkaXY+PGJyPjwvZGl2PjxkaXY+aWYgSSBsb29rIGF0IHRoZSBkaXNrIGxvYWRzIGF0IHRo
ZSB0aW1lLCBJIHNlZSBhIGRyYW1hdGljIGluY3JlYXNlIGluIGRpc2sgcmVhZHMgdGhhdCBjb3Jy
ZXNwb25kIHRvIHRoZSBzbG93IHdyaXRlcyBzbyBJJiMzOTttIGd1ZXNzaW5nIGF0IGxlYXN0IHNv
bWUgd3JpdGVzIGFyZSB3YWl0aW5nIGluIHRoZSBxdWV1ZSBhcyB5b3UgY2FuIHNlZSB0aGVyZSAt
IHRoYW5rcyB0byBsYXVyZW5jZSBmb3IgdGhlIHBhdGNoIHRvIHNob3cgZGlzayByZWFkIHdhaXQg
dGltZXMgOyk8L2Rpdj48ZGl2Pjxicj48L2Rpdj48ZGl2PjxkaXY+PGZvbnQgZmFjZT0ibW9ub3Nw
YWNlLCBtb25vc3BhY2UiPiMgRElTSyBTVEFUSVNUSUNTICgvc2VjKTwvZm9udD48L2Rpdj48ZGl2
Pjxmb250IGZhY2U9Im1vbm9zcGFjZSwgbW9ub3NwYWNlIj4jIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgICZsdDstLS0tLS0tLS1yZWFkcy0tLS0tLS0tLS0tLS0tLSZndDsmbHQ7LS0tLS0tLS0t
d3JpdGVzLS0tLS0tLS0tLS0tLS0mZ3Q7Jmx0Oy0tLS0tLS0tYXZlcmFnZXMtLS0tLS0tLSZndDsg
UGN0PC9mb250PjwvZGl2PjxkaXY+PGZvbnQgZmFjZT0ibW9ub3NwYWNlLCBtb25vc3BhY2UiPiNU
aW1lIMKgIMKgIE5hbWUgwqAgwqAgwqAgS0J5dGVzIE1lcmdlZCDCoElPcyBTaXplIMKgV2FpdCDC
oEtCeXRlcyBNZXJnZWQgwqBJT3MgU2l6ZSDCoFdhaXQgwqBSV1NpemUgwqBRTGVuIMKgV2FpdCBT
dmNUaW0gVXRpbDwvZm9udD48L2Rpdj48ZGl2Pjxmb250IGZhY2U9Im1vbm9zcGFjZSwgbW9ub3Nw
YWNlIj4xMjo0NTozMCBzZGIgwqAgwqAgwqAgwqAgwqAgwqAgwqAwIMKgIMKgIMKgMCDCoCDCoDAg
wqAgwqAwIMKgIMKgIDAgwqAyNzAwNDAgwqAgwqAxMDUgMjI3NiDCoDExOSDCoCDCoCA0IMKgIMKg
IDExOCDCoCDCoDE2IMKgIMKgIDQgwqAgwqAgwqAwIMKgIDYyPC9mb250PjwvZGl2PjxkaXY+PGZv
bnQgZmFjZT0ibW9ub3NwYWNlLCBtb25vc3BhY2UiPjEyOjQ1OjMxIHNkYiDCoCDCoCDCoCDCoCDC
oCDCoCDCoDAgwqAgwqAgwqAwIMKgIMKgMCDCoCDCoDAgwqAgwqAgMCDCoDI3Mzc3NiDCoCDCoDEy
MCAyMjYyIMKgMTIxIMKgIMKgIDQgwqAgwqAgMTIxIMKgIMKgMTggwqAgwqAgNCDCoCDCoCDCoDAg
wqAgNTc8L2ZvbnQ+PC9kaXY+PGRpdj48Zm9udCBmYWNlPSJtb25vc3BhY2UsIG1vbm9zcGFjZSI+
MTI6NDU6MzIgc2RiIMKgIMKgIMKgIMKgIMKgIMKgIMKgNCDCoCDCoCDCoDAgwqAgwqAxIMKgIMKg
NCDCoCDCoCAwIMKgMTAwMTY0IMKgIMKgIDU3IMKgOTA5IMKgMTEwIMKgIMKgIDQgwqAgwqAgMTEw
IMKgIMKgIDYgwqAgwqAgNCDCoCDCoCDCoDAgwqAgODQ8L2ZvbnQ+PC9kaXY+PGRpdj48Zm9udCBm
YWNlPSJtb25vc3BhY2UsIG1vbm9zcGFjZSI+MTI6NDU6MzMgc2RiIMKgIMKgIMKgIMKgIMKgIMKg
IMKgMCDCoCDCoCDCoDAgwqAgwqAwIMKgIMKgMCDCoCDCoCAwIMKgMjI5OTkyIMKgIMKgIDg3IDE5
MjQgwqAxMjAgwqAgwqAgMSDCoCDCoCAxMTkgwqAgwqAgMiDCoCDCoCAxIMKgIMKgIMKgMCDCoCA2
ODwvZm9udD48L2Rpdj48ZGl2Pjxmb250IGZhY2U9Im1vbm9zcGFjZSwgbW9ub3NwYWNlIj4xMjo0
NTozNCBzZGIgwqAgwqAgwqAgwqAgwqAgwqAgwqA0IMKgIMKgIMKgMCDCoCDCoDEgwqAgwqA0IMKg
IMKgIDQgwqAxNTM1MjggwqAgwqAgNTkgMTMwNCDCoDExOCDCoCDCoCAwIMKgIMKgIDExNyDCoCDC
oCAxIMKgIMKgIDAgwqAgwqAgwqAwIMKgIDc4PC9mb250PjwvZGl2PjxkaXY+PGZvbnQgZmFjZT0i
bW9ub3NwYWNlLCBtb25vc3BhY2UiPjEyOjQ1OjM1IHNkYiDCoCDCoCDCoCDCoCDCoCDCoCDCoDAg
wqAgwqAgwqAwIMKgIMKgMCDCoCDCoDAgwqAgwqAgMCDCoDIyMDg5NiDCoCDCoCA5NyAxODk1IMKg
MTE3IMKgIMKgIDEgwqAgwqAgMTE2IMKgIMKgIDEgwqAgwqAgMSDCoCDCoCDCoDAgwqAgNjI8L2Zv
bnQ+PC9kaXY+PGRpdj48Zm9udCBmYWNlPSJtb25vc3BhY2UsIG1vbm9zcGFjZSI+MTI6NDU6MzYg
c2RiIMKgIMKgIMKgIMKgIMKgIMKgIMKgMCDCoCDCoCDCoDAgwqAgwqAwIMKgIMKgMCDCoCDCoCAw
IMKgNDE5MDg0IMKgIMKgMTk3IDM1MDQgwqAxMjAgwqAgwqAgMCDCoCDCoCAxMTkgwqAgwqAgMSDC
oCDCoCAwIMKgIMKgIMKgMCDCoCAzMjwvZm9udD48L2Rpdj48ZGl2Pjxmb250IGZhY2U9Im1vbm9z
cGFjZSwgbW9ub3NwYWNlIj4xMjo0NTozNyBzZGIgwqAgwqAgwqAgwqAgwqAgwqAgwqAwIMKgIMKg
IMKgMCDCoCDCoDAgwqAgwqAwIMKgIMKgIDAgwqA0MjgwNzYgwqAgwqAxOTMgMzY2MiDCoDExNyDC
oCDCoCAwIMKgIMKgIDExNiDCoCDCoCAxIMKgIMKgIDAgwqAgwqAgwqAwIMKgIDMyPC9mb250Pjwv
ZGl2PjxkaXY+PGZvbnQgZmFjZT0ibW9ub3NwYWNlLCBtb25vc3BhY2UiPjEyOjQ1OjM4IHNkYiDC
oCDCoCDCoCDCoCDCoCDCoCDCoDAgwqAgwqAgwqAwIMKgIMKgMCDCoCDCoDAgwqAgwqAgMCDCoDQy
ODQ5MiDCoCDCoDE4MSAzNTYwIMKgMTIwIMKgIMKgIDAgwqAgwqAgMTIwIMKgIMKgIDEgwqAgwqAg
MCDCoCDCoCDCoDAgwqAgMzA8L2ZvbnQ+PC9kaXY+PGRpdj48Zm9udCBmYWNlPSJtb25vc3BhY2Us
IG1vbm9zcGFjZSI+MTI6NDU6Mzkgc2RiIMKgIMKgIMKgIMKgIMKgIMKgIMKgMCDCoCDCoCDCoDAg
wqAgwqAwIMKgIMKgMCDCoCDCoCAwIMKgNDI2MDI0IMKgIMKgMTk5IDM2NDEgwqAxMTcgwqAgwqAg
MCDCoCDCoCAxMTcgwqAgwqAgMSDCoCDCoCAwIMKgIMKgIMKgMCDCoCAzMjwvZm9udD48L2Rpdj48
ZGl2Pjxmb250IGZhY2U9Im1vbm9zcGFjZSwgbW9ub3NwYWNlIj4xMjo0NTo0MCBzZGIgwqAgwqAg
wqAgwqAgwqAgwqAgwqAwIMKgIMKgIMKgMCDCoCDCoDAgwqAgwqAwIMKgIMKgIDAgwqA0Mjk3NjQg
wqAgwqAyMDAgMzU4OSDCoDEyMCDCoCDCoCAwIMKgIMKgIDExOSDCoCDCoCAxIMKgIMKgIDAgwqAg
wqAgwqAwIMKgIDI4PC9mb250PjwvZGl2PjxkaXY+PGZvbnQgZmFjZT0ibW9ub3NwYWNlLCBtb25v
c3BhY2UiPjEyOjQ1OjQxIHNkYiDCoCDCoCDCoCDCoCDCoCDCoCDCoDAgwqAgwqAgwqAwIMKgIMKg
MCDCoCDCoDAgwqAgwqAgMCDCoDQxMDIwNCDCoCDCoDE2NSAzNDMwIMKgMTIwIMKgIMKgIDAgwqAg
wqAgMTE5IMKgIMKgIDMgwqAgwqAgMCDCoCDCoCDCoDAgwqAgMzY8L2ZvbnQ+PC9kaXY+PGRpdj48
Zm9udCBmYWNlPSJtb25vc3BhY2UsIG1vbm9zcGFjZSI+MTI6NDU6NDIgc2RiIMKgIMKgIMKgIMKg
IMKgIMKgIMKgMCDCoCDCoCDCoDAgwqAgwqAwIMKgIMKgMCDCoCDCoCAwIMKgNDA2MTkyIMKgIMKg
MTk2IDM0MzcgwqAxMTggwqAgwqAgMCDCoCDCoCAxMTggwqAgwqAgNSDCoCDCoCAwIMKgIMKgIMKg
MCDCoCAzOTwvZm9udD48L2Rpdj48ZGl2Pjxmb250IGZhY2U9Im1vbm9zcGFjZSwgbW9ub3NwYWNl
Ij4xMjo0NTo0MyBzZGIgwqAgwqAgwqAgwqAgwqAgwqAgwqAwIMKgIMKgIMKgMCDCoCDCoDAgwqAg
wqAwIMKgIMKgIDAgwqA0MjA5NTIgwqAgwqAxNzUgMzU1MiDCoDExOSDCoCDCoCAwIMKgIMKgIDEx
OCDCoCDCoCAxIMKgIMKgIDAgwqAgwqAgwqAwIMKgIDM0PC9mb250PjwvZGl2PjxkaXY+PGZvbnQg
ZmFjZT0ibW9ub3NwYWNlLCBtb25vc3BhY2UiPjEyOjQ1OjQ0IHNkYiDCoCDCoCDCoCDCoCDCoCDC
oCDCoDAgwqAgwqAgwqAwIMKgIMKgMCDCoCDCoDAgwqAgwqAgMCDCoDQyODQyNCDCoCDCoDE5NyAz
NjQ1IMKgMTE4IMKgIMKgIDAgwqAgwqAgMTE3IMKgIMKgIDEgwqAgwqAgMCDCoCDCoCDCoDAgwqAg
MzE8L2ZvbnQ+PC9kaXY+PGRpdj48Zm9udCBmYWNlPSJtb25vc3BhY2UsIG1vbm9zcGFjZSI+MTI6
NDU6NDUgc2RiIMKgIMKgIMKgIMKgIMKgIMKgIMKgMCDCoCDCoCDCoDAgwqAgwqAwIMKgIMKgMCDC
oCDCoCAwIMKgMTkyNDY0IMKgIMKgIDc2IDE1OTkgwqAxMjAgwqAgwqAgOCDCoCDCoCAxMjAgwqAg
wqAxOCDCoCDCoCA4IMKgIMKgIMKgMCDCoCA3NTwvZm9udD48L2Rpdj48ZGl2Pjxmb250IGZhY2U9
Im1vbm9zcGFjZSwgbW9ub3NwYWNlIj4xMjo0NTo0NiBzZGIgwqAgwqAgwqAgwqAgwqAgwqAgwqAw
IMKgIMKgIMKgMCDCoCDCoDAgwqAgwqAwIMKgIMKgIDAgwqAzNDA1MjIgwqAgwqAyMDUgMjk1MSDC
oDExNSDCoCDCoCAyIMKgIMKgIDExNSDCoCDCoDE2IMKgIMKgIDIgwqAgwqAgwqAwIMKgIDQxPC9m
b250PjwvZGl2PjxkaXY+PGZvbnQgZmFjZT0ibW9ub3NwYWNlLCBtb25vc3BhY2UiPjEyOjQ1OjQ3
IHNkYiDCoCDCoCDCoCDCoCDCoCDCoCDCoDAgwqAgwqAgwqAwIMKgIMKgMCDCoCDCoDAgwqAgwqAg
MCDCoDQyOTEyOCDCoCDCoDE5MyAzNjY0IMKgMTE3IMKgIMKgIDAgwqAgwqAgMTE3IMKgIMKgIDEg
wqAgwqAgMCDCoCDCoCDCoDAgwqAgMjg8L2ZvbnQ+PC9kaXY+PGRpdj48Zm9udCBmYWNlPSJtb25v
c3BhY2UsIG1vbm9zcGFjZSI+MTI6NDU6NDggc2RiIMKgIMKgIMKgIMKgIMKgIMKgIMKgMCDCoCDC
oCDCoDAgwqAgwqAwIMKgIMKgMCDCoCDCoCAwIMKgNDAyNjAwIMKgIMKgMTY0IDMzMTEgwqAxMjIg
wqAgwqAgMCDCoCDCoCAxMjEgwqAgwqAgMyDCoCDCoCAwIMKgIMKgIMKgMCDCoCAzOTwvZm9udD48
L2Rpdj48ZGl2Pjxmb250IGZhY2U9Im1vbm9zcGFjZSwgbW9ub3NwYWNlIj4xMjo0NTo0OSBzZGIg
wqAgwqAgwqAgwqAgwqAgwqAgwqAwIMKgIMKgIMKgMCDCoCDCoDAgwqAgwqAwIMKgIMKgIDAgwqA0
MzUzMTYgwqAgwqAxOTUgMzcwMSDCoDExOCDCoCDCoCAwIMKgIMKgIDExNyDCoCDCoCAxIMKgIMKg
IDAgwqAgwqAgwqAwIMKgIDM2PC9mb250PjwvZGl2PjxkaXY+PGZvbnQgZmFjZT0ibW9ub3NwYWNl
LCBtb25vc3BhY2UiPjEyOjQ1OjUwIHNkYiDCoCDCoCDCoCDCoCDCoCDCoCDCoDAgwqAgwqAgwqAw
IMKgIMKgMCDCoCDCoDAgwqAgwqAgMCDCoDM2Nzk3NiDCoCDCoDE2MiAzMTUyIMKgMTE3IMKgIMKg
IDEgwqAgwqAgMTE2IMKgIMKgIDcgwqAgwqAgMSDCoCDCoCDCoDAgwqAgNDY8L2ZvbnQ+PC9kaXY+
PGRpdj48Zm9udCBmYWNlPSJtb25vc3BhY2UsIG1vbm9zcGFjZSI+MTI6NDU6NTEgc2RiIMKgIMKg
IMKgIMKgIMKgIMKgIMKgMCDCoCDCoCDCoDAgwqAgwqAwIMKgIMKgMCDCoCDCoCAwIMKgMjU1NzE2
IMKgIMKgMTI1IDIxNTMgwqAxMTkgwqAgwqAgNCDCoCDCoCAxMTggwqAgwqAxNiDCoCDCoCA0IMKg
IMKgIMKgMCDCoCA2MDwvZm9udD48L2Rpdj48ZGl2Pjxmb250IGZhY2U9Im1vbm9zcGFjZSwgbW9u
b3NwYWNlIj48YnI+PC9mb250PjwvZGl2PjxkaXY+PGZvbnQgZmFjZT0ibW9ub3NwYWNlLCBtb25v
c3BhY2UiPiMgRElTSyBTVEFUSVNUSUNTICgvc2VjKTwvZm9udD48L2Rpdj48ZGl2Pjxmb250IGZh
Y2U9Im1vbm9zcGFjZSwgbW9ub3NwYWNlIj4jIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgICZs
dDstLS0tLS0tLS1yZWFkcy0tLS0tLS0tLS0tLS0tLSZndDsmbHQ7LS0tLS0tLS0td3JpdGVzLS0t
LS0tLS0tLS0tLS0mZ3Q7Jmx0Oy0tLS0tLS0tYXZlcmFnZXMtLS0tLS0tLSZndDsgUGN0PC9mb250
PjwvZGl2PjxkaXY+PGZvbnQgZmFjZT0ibW9ub3NwYWNlLCBtb25vc3BhY2UiPiNUaW1lIMKgIMKg
IE5hbWUgwqAgwqAgwqAgS0J5dGVzIE1lcmdlZCDCoElPcyBTaXplIMKgV2FpdCDCoEtCeXRlcyBN
ZXJnZWQgwqBJT3MgU2l6ZSDCoFdhaXQgwqBSV1NpemUgwqBRTGVuIMKgV2FpdCBTdmNUaW0gVXRp
bDwvZm9udD48L2Rpdj48ZGl2Pjxmb250IGZhY2U9Im1vbm9zcGFjZSwgbW9ub3NwYWNlIj4xMjo0
NTo1MiBzZGIgwqAgwqAgwqAgwqAgwqAgwqAgwqAwIMKgIMKgIMKgMCDCoCDCoDAgwqAgwqAwIMKg
IMKgIDAgwqAzNjAxNDQgwqAgwqAxNDkgMzAwNiDCoDEyMCDCoCDCoCAxIMKgIMKgIDExOSDCoCDC
oCA5IMKgIMKgIDEgwqAgwqAgwqAwIMKgIDQ2PC9mb250PjwvZGl2PjxkaXY+PGZvbnQgZmFjZT0i
bW9ub3NwYWNlLCBtb25vc3BhY2UiPjEyOjQ1OjUzIHNkYiDCoCDCoCDCoCDCoCDCoCDCoCDCoDAg
wqAgwqAgwqAwIMKgIMKgMCDCoCDCoDAgwqAgwqAgMCDCoDM0MzUwMCDCoCDCoDE2MiAyOTA5IMKg
MTE4IMKgIMKgIDEgwqAgwqAgMTE4IMKgIMKgMTEgwqAgwqAgMSDCoCDCoCDCoDAgwqAgNDM8L2Zv
bnQ+PC9kaXY+PGRpdj48Zm9udCBmYWNlPSJtb25vc3BhY2UsIG1vbm9zcGFjZSI+MTI6NDU6NTQg
c2RiIMKgIMKgIMKgIMKgIMKgIMKgIMKgMCDCoCDCoCDCoDAgwqAgwqAwIMKgIMKgMCDCoCDCoCAw
IMKgMjU2NjM2IMKgIMKgMTE5IDIxODggwqAxMTcgwqAgwqAgMiDCoCDCoCAxMTcgwqAgwqAxMSDC
oCDCoCAyIMKgIMKgIMKgMCDCoCA1NDwvZm9udD48L2Rpdj48ZGl2Pjxmb250IGZhY2U9Im1vbm9z
cGFjZSwgbW9ub3NwYWNlIj4xMjo0NTo1NSBzZGIgwqAgwqAgwqAgwqAgwqAgwqAgwqAwIMKgIMKg
IMKgMCDCoCDCoDAgwqAgwqAwIMKgIMKgIDAgwqAxNDkwMDAgwqAgwqAgNDcgMTI2MCDCoDExOCDC
oCDCoDE0IMKgIMKgIDExOCDCoCDCoDIyIMKgIMKgMTQgwqAgwqAgwqAwIMKgIDc5PC9mb250Pjwv
ZGl2PjxkaXY+PGZvbnQgZmFjZT0ibW9ub3NwYWNlLCBtb25vc3BhY2UiPjEyOjQ1OjU2IHNkYiDC
oCDCoCDCoCDCoCDCoCDCoCDCoDAgwqAgwqAgwqAwIMKgIMKgMCDCoCDCoDAgwqAgwqAgMCDCoDE5
ODU0NCDCoCDCoCA4OCAxNjU0IMKgMTIwIMKgIMKgIDcgwqAgwqAgMTIwIMKgIMKgMTkgwqAgwqAg
NyDCoCDCoCDCoDAgwqAgNjc8L2ZvbnQ+PC9kaXY+PGRpdj48Zm9udCBmYWNlPSJtb25vc3BhY2Us
IG1vbm9zcGFjZSI+MTI6NDU6NTcgc2RiIMKgIMKgIMKgIMKgIMKgIMKgIMKgMCDCoCDCoCDCoDAg
wqAgwqAwIMKgIMKgMCDCoCDCoCAwIMKgMzIwNjg4IMKgIMKgMTUxIDI3MzEgwqAxMTcgwqAgwqAg
MSDCoCDCoCAxMTcgwqAgwqAgOCDCoCDCoCAxIMKgIMKgIMKgMCDCoCA1MzwvZm9udD48L2Rpdj48
ZGl2Pjxmb250IGZhY2U9Im1vbm9zcGFjZSwgbW9ub3NwYWNlIj4xMjo0NTo1OCBzZGIgwqAgwqAg
wqAgwqAgwqAgwqAgwqAwIMKgIMKgIMKgMCDCoCDCoDAgwqAgwqAwIMKgIMKgIDAgwqA0MjIxNzYg
wqAgwqAxOTAgMzUzMiDCoDEyMCDCoCDCoCAwIMKgIMKgIDExOSDCoCDCoCAxIMKgIMKgIDAgwqAg
wqAgwqAwIMKgIDMyPC9mb250PjwvZGl2PjxkaXY+PGZvbnQgZmFjZT0ibW9ub3NwYWNlLCBtb25v
c3BhY2UiPjEyOjQ1OjU5IHNkYiDCoCDCoCDCoCDCoCDCoCDCoCDCoDAgwqAgwqAgwqAwIMKgIMKg
MCDCoCDCoDAgwqAgwqAgMCDCoDI2NjU0MCDCoCDCoDExNSAyMjMzIMKgMTE5IMKgIMKgIDUgwqAg
wqAgMTE5IMKgIMKgMTMgwqAgwqAgNSDCoCDCoCDCoDAgwqAgOTM8L2ZvbnQ+PC9kaXY+PGRpdj48
Zm9udCBmYWNlPSJtb25vc3BhY2UsIG1vbm9zcGFjZSI+MTI6NDY6MDAgc2RiIMKgIMKgIMKgIMKg
IMKgIMKgIMKgOCDCoCDCoCDCoDAgwqAgwqAyIMKgIMKgNCDCoCA2OTAgwqAyOTExMTYgwqAgwqAx
MjkgMjQ2MyDCoDExOCDCoCDCoCAzIMKgIMKgIDExOCDCoCDCoCA5IMKgIMKgIDMgwqAgwqAgwqAw
IMKgIDgyPC9mb250PjwvZGl2PjxkaXY+PGZvbnQgZmFjZT0ibW9ub3NwYWNlLCBtb25vc3BhY2Ui
PjEyOjQ2OjAxIHNkYiDCoCDCoCDCoCDCoCDCoCDCoCDCoDAgwqAgwqAgwqAwIMKgIMKgMCDCoCDC
oDAgwqAgwqAgMCDCoDI0OTk2NCDCoCDCoDExOCAyMTYwIMKgMTE2IMKgIMKgIDQgwqAgwqAgMTE1
IMKgIMKgMTUgwqAgwqAgNCDCoCDCoCDCoDAgwqAgNjA8L2ZvbnQ+PC9kaXY+PGRpdj48Zm9udCBm
YWNlPSJtb25vc3BhY2UsIG1vbm9zcGFjZSI+MTI6NDY6MDIgc2RiIMKgIMKgIMKgIMKgIMKgIDQ3
MzYgwqAgwqAgwqAwIMKgIDM3IMKgMTI4IMKgIMKgIDAgwqA0MjQ2ODAgwqAgwqAxNjcgMzUyMiDC
oDEyMSDCoCDCoCAwIMKgIMKgIDEyMCDCoCDCoCAxIMKgIMKgIDAgwqAgwqAgwqAwIMKgIDI4PC9m
b250PjwvZGl2PjxkaXY+PGZvbnQgZmFjZT0ibW9ub3NwYWNlLCBtb25vc3BhY2UiPjEyOjQ2OjAz
IHNkYiDCoCDCoCDCoCDCoCDCoCA1MDE2IMKgIMKgIMKgMCDCoCA0MiDCoDExOSDCoCDCoCAwIMKg
MzkxMzY0IMKgIMKgMTk2IDMzNDQgwqAxMTcgwqAgwqAgMCDCoCDCoCAxMTcgwqAgwqAgNiDCoCDC
oCAwIMKgIMKgIMKgMCDCoCAzNDwvZm9udD48L2Rpdj48ZGl2Pjxmb250IGZhY2U9Im1vbm9zcGFj
ZSwgbW9ub3NwYWNlIj4xMjo0NjowNCBzZGIgwqAgwqAgwqAgwqAgwqAgwqAgwqAwIMKgIMKgIMKg
MCDCoCDCoDAgwqAgwqAwIMKgIMKgIDAgwqA0MTU0MzYgwqAgwqAxNzIgMzUwMSDCoDExOSDCoCDC
oCAwIMKgIMKgIDExOCDCoCDCoCAyIMKgIMKgIDAgwqAgwqAgwqAwIMKgIDMzPC9mb250PjwvZGl2
PjxkaXY+PGZvbnQgZmFjZT0ibW9ub3NwYWNlLCBtb25vc3BhY2UiPjEyOjQ2OjA1IHNkYiDCoCDC
oCDCoCDCoCDCoCDCoCDCoDAgwqAgwqAgwqAwIMKgIMKgMCDCoCDCoDAgwqAgwqAgMCDCoDM5ODcz
NiDCoCDCoDE5MiAzMzczIMKgMTE4IMKgIMKgIDAgwqAgwqAgMTE4IMKgIMKgIDMgwqAgwqAgMCDC
oCDCoCDCoDAgwqAgMzk8L2ZvbnQ+PC9kaXY+PGRpdj48Zm9udCBmYWNlPSJtb25vc3BhY2UsIG1v
bm9zcGFjZSI+MTI6NDY6MDYgc2RiIMKgIMKgIMKgIMKgIMKgIMKgIMKgMCDCoCDCoCDCoDAgwqAg
wqAwIMKgIMKgMCDCoCDCoCAwIMKgMzY3MjkyIMKgIMKgMTU1IDMwMTUgwqAxMjIgwqAgwqAgMCDC
oCDCoCAxMjEgwqAgwqAgNiDCoCDCoCAwIMKgIMKgIMKgMCDCoCAzOTwvZm9udD48L2Rpdj48ZGl2
Pjxmb250IGZhY2U9Im1vbm9zcGFjZSwgbW9ub3NwYWNlIj4xMjo0NjowNyBzZGIgwqAgwqAgwqAg
wqAgwqAgwqAgwqAwIMKgIMKgIMKgMCDCoCDCoDAgwqAgwqAwIMKgIMKgIDAgwqA0MjAzOTIgwqAg
wqAyMDEgMzYxNCDCoDExNiDCoCDCoCAwIMKgIMKgIDExNiDCoCDCoCAxIMKgIMKgIDAgwqAgwqAg
wqAwIMKgIDMwPC9mb250PjwvZGl2PjxkaXY+PGZvbnQgZmFjZT0ibW9ub3NwYWNlLCBtb25vc3Bh
Y2UiPjEyOjQ2OjA4IHNkYiDCoCDCoCDCoCDCoCDCoCDCoCDCoDAgwqAgwqAgwqAwIMKgIMKgMCDC
oCDCoDAgwqAgwqAgMCDCoDQyNDgyOCDCoCDCoDE3MiAzNTQ3IMKgMTIwIMKgIMKgIDAgwqAgwqAg
MTE5IMKgIMKgIDEgwqAgwqAgMCDCoCDCoCDCoDAgwqAgMzI8L2ZvbnQ+PC9kaXY+PGRpdj48Zm9u
dCBmYWNlPSJtb25vc3BhY2UsIG1vbm9zcGFjZSI+MTI6NDY6MDkgc2RiIMKgIMKgIMKgIMKgIMKg
IMKgIMKgMCDCoCDCoCDCoDAgwqAgwqAwIMKgIMKgMCDCoCDCoCAwIMKgNTAwMzgwIMKgIMKgMjM0
IDQyNzcgwqAxMTcgwqAgwqAgMCDCoCDCoCAxMTYgwqAgwqAgMiDCoCDCoCAwIMKgIMKgIMKgMCDC
oCAzNDwvZm9udD48L2Rpdj48ZGl2Pjxmb250IGZhY2U9Im1vbm9zcGFjZSwgbW9ub3NwYWNlIj4x
Mjo0NjoxMCBzZGIgwqAgwqAgwqAgwqAgwqAgwqAgwqAwIMKgIMKgIMKgMCDCoCDCoDAgwqAgwqAw
IMKgIMKgIDAgwqAxMDQ1MDAgwqAgwqAgwqA3IMKgNjk4IMKgMTUwIMKgIMKgIDAgwqAgwqAgMTQ5
IMKgIMKgIDEgwqAgwqAgMCDCoCDCoCDCoDEgwqAgODc8L2ZvbnQ+PC9kaXY+PGRpdj48Zm9udCBm
YWNlPSJtb25vc3BhY2UsIG1vbm9zcGFjZSI+MTI6NDY6MTEgc2RiIMKgIMKgIMKgIMKgIMKgIMKg
IMKgOCDCoCDCoCDCoDAgwqAgwqAxIMKgIMKgOCDCoDEyNjAgwqAgNzcyNTIgwqAgwqAgNDUgwqA2
NDcgwqAxMTkgwqAgwqAgMCDCoCDCoCAxMTkgwqAgwqAgMSDCoCDCoCAyIMKgIMKgIMKgMSDCoCA5
MjwvZm9udD48L2Rpdj48ZGl2Pjxmb250IGZhY2U9Im1vbm9zcGFjZSwgbW9ub3NwYWNlIj4xMjo0
NjoxMiBzZGIgwqAgwqAgwqAgwqAgwqAgwqAgwqA4IMKgIMKgIMKgMCDCoCDCoDEgwqAgwqA4IMKg
MTI0NCDCoCA3Mzk1NiDCoCDCoCAzMSDCoDYxNSDCoDEyMCDCoCDCoCAwIMKgIMKgIDEyMCDCoCDC
oCAxIMKgIMKgIDIgwqAgwqAgwqAxIMKgIDk0PC9mb250PjwvZGl2PjxkaXY+PGZvbnQgZmFjZT0i
bW9ub3NwYWNlLCBtb25vc3BhY2UiPjEyOjQ2OjEzIHNkYiDCoCDCoCDCoCDCoCDCoCDCoCDCoDgg
wqAgwqAgwqAwIMKgIMKgMSDCoCDCoDggwqAgMjI4IMKgMTQ5NTUyIMKgIMKgIDY0IDEyNTYgwqAx
MTkgwqAgwqAgMCDCoCDCoCAxMTggwqAgwqAgMSDCoCDCoCAwIMKgIMKgIMKgMCDCoCA4NTwvZm9u
dD48L2Rpdj48ZGl2Pjxmb250IGZhY2U9Im1vbm9zcGFjZSwgbW9ub3NwYWNlIj48YnI+PC9mb250
PjwvZGl2PjxkaXY+PGZvbnQgZmFjZT0ibW9ub3NwYWNlLCBtb25vc3BhY2UiPiMgRElTSyBTVEFU
SVNUSUNTICgvc2VjKTwvZm9udD48L2Rpdj48ZGl2Pjxmb250IGZhY2U9Im1vbm9zcGFjZSwgbW9u
b3NwYWNlIj4jIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgICZsdDstLS0tLS0tLS1yZWFkcy0t
LS0tLS0tLS0tLS0tLSZndDsmbHQ7LS0tLS0tLS0td3JpdGVzLS0tLS0tLS0tLS0tLS0mZ3Q7Jmx0
Oy0tLS0tLS0tYXZlcmFnZXMtLS0tLS0tLSZndDsgUGN0PC9mb250PjwvZGl2PjxkaXY+PGZvbnQg
ZmFjZT0ibW9ub3NwYWNlLCBtb25vc3BhY2UiPiNUaW1lIMKgIMKgIE5hbWUgwqAgwqAgwqAgS0J5
dGVzIE1lcmdlZCDCoElPcyBTaXplIMKgV2FpdCDCoEtCeXRlcyBNZXJnZWQgwqBJT3MgU2l6ZSDC
oFdhaXQgwqBSV1NpemUgwqBRTGVuIMKgV2FpdCBTdmNUaW0gVXRpbDwvZm9udD48L2Rpdj48ZGl2
Pjxmb250IGZhY2U9Im1vbm9zcGFjZSwgbW9ub3NwYWNlIj4xMjo0NjoxNCBzZGIgwqAgwqAgwqAg
wqAgwqAgwqAgwqA4IMKgIMKgIMKgMCDCoCDCoDEgwqAgwqA4IMKgMTIzMiDCoCAzNzEyNCDCoCDC
oCAyOCDCoDMxOSDCoDExNiDCoCDCoCAwIMKgIMKgIDExNiDCoCDCoCAxIMKgIMKgIDMgwqAgwqAg
wqAzIMKgIDk5PC9mb250PjwvZGl2PjxkaXY+PGZvbnQgZmFjZT0ibW9ub3NwYWNlLCBtb25vc3Bh
Y2UiPjEyOjQ2OjE1IHNkYiDCoCDCoCDCoCDCoCDCoCDCoCAxNiDCoCDCoCDCoDAgwqAgwqAyIMKg
IMKgOCDCoCA3MjAgwqAgwqAyNzc2IMKgIMKgIDIzIMKgMTIwIMKgIDIzIMKgIMKgIDEgwqAgwqAg
wqAyMiDCoCDCoCAxIMKgIMKgMTMgwqAgwqAgwqA4IMKgIDk5PC9mb250PjwvZGl2PjxkaXY+PGZv
bnQgZmFjZT0ibW9ub3NwYWNlLCBtb25vc3BhY2UiPjEyOjQ2OjE2IHNkYiDCoCDCoCDCoCDCoCDC
oCDCoCDCoDAgwqAgwqAgwqAwIMKgIMKgMCDCoCDCoDAgwqAgwqAgMCDCoDEwODE4MCDCoCDCoCAx
NiDCoDgyMyDCoDEzMSDCoCDCoCAwIMKgIMKgIDEzMSDCoCDCoCAxIMKgIMKgIDAgwqAgwqAgwqAx
IMKgIDkwPC9mb250PjwvZGl2PjxkaXY+PGZvbnQgZmFjZT0ibW9ub3NwYWNlLCBtb25vc3BhY2Ui
PjEyOjQ2OjE3IHNkYiDCoCDCoCDCoCDCoCDCoCDCoCDCoDggwqAgwqAgwqAwIMKgIMKgMSDCoCDC
oDggwqAxMjYwIMKgIDM3MTM2IMKgIMKgIDI4IMKgMzIyIMKgMTE1IMKgIMKgIDAgwqAgwqAgMTE0
IMKgIMKgIDEgwqAgwqAgMyDCoCDCoCDCoDIgwqAgOTQ8L2ZvbnQ+PC9kaXY+PGRpdj48Zm9udCBm
YWNlPSJtb25vc3BhY2UsIG1vbm9zcGFjZSI+MTI6NDY6MTggc2RiIMKgIMKgIMKgIMKgIMKgIMKg
IMKgOCDCoCDCoCDCoDAgwqAgwqAxIMKgIMKgOCDCoDEyNTIgwqAxMDg2ODAgwqAgwqAgNTcgwqA4
NzUgwqAxMjQgwqAgwqAgMCDCoCDCoCAxMjQgwqAgwqAgMSDCoCDCoCAxIMKgIMKgIMKgMSDCoCA4
ODwvZm9udD48L2Rpdj48ZGl2Pjxmb250IGZhY2U9Im1vbm9zcGFjZSwgbW9ub3NwYWNlIj4xMjo0
NjoxOSBzZGIgwqAgwqAgwqAgwqAgwqAgwqAgwqAwIMKgIMKgIMKgMCDCoCDCoDAgwqAgwqAwIMKg
IMKgIDAgwqAgwqAgwqAgMCDCoCDCoCDCoDAgwqAgwqAwIMKgIMKgMCDCoCDCoCAwIMKgIMKgIMKg
IDAgwqAgwqAgMSDCoCDCoCAwIMKgIMKgIMKgMCDCoDEwMDwvZm9udD48L2Rpdj48ZGl2Pjxmb250
IGZhY2U9Im1vbm9zcGFjZSwgbW9ub3NwYWNlIj4xMjo0NjoyMCBzZGIgwqAgwqAgwqAgwqAgwqAg
wqAgMTYgwqAgwqAgwqAwIMKgIMKgMiDCoCDCoDggwqAgNjE4IMKgIDgxNTE2IMKgIMKgIDQ5IMKg
Njg1IMKgMTE5IMKgIMKgIDAgwqAgwqAgMTE4IMKgIMKgIDEgwqAgwqAgMSDCoCDCoCDCoDEgwqAg
OTQ8L2ZvbnQ+PC9kaXY+PGRpdj48Zm9udCBmYWNlPSJtb25vc3BhY2UsIG1vbm9zcGFjZSI+MTI6
NDY6MjEgc2RiIMKgIMKgIMKgIMKgIMKgIMKgIDE2IMKgIMKgIMKgMCDCoCDCoDIgwqAgwqA4IMKg
IDY0MCDCoDIyNTc4OCDCoCDCoDEwNiAxOTA3IMKgMTE4IMKgIMKgIDAgwqAgwqAgMTE4IMKgIMKg
IDEgwqAgwqAgMCDCoCDCoCDCoDAgwqAgNzU8L2ZvbnQ+PC9kaXY+PGRpdj48Zm9udCBmYWNlPSJt
b25vc3BhY2UsIG1vbm9zcGFjZSI+MTI6NDY6MjIgc2RiIMKgIMKgIMKgIMKgIMKgIMKgIDMyIMKg
IMKgIMKgMCDCoCDCoDQgwqAgwqA4IMKgIMKgOTUgwqAgNzM4OTIgwqAgwqAgMTcgwqA2MjcgwqAx
MTggwqAgwqAgMCDCoCDCoCAxMTcgwqAgwqAgMSDCoCDCoCAwIMKgIMKgIMKgMSDCoCA5MzwvZm9u
dD48L2Rpdj48ZGl2Pjxmb250IGZhY2U9Im1vbm9zcGFjZSwgbW9ub3NwYWNlIj4xMjo0NjoyMyBz
ZGIgwqAgwqAgwqAgwqAgwqAgwqAgMjQgwqAgwqAgwqAwIMKgIMKgMyDCoCDCoDggwqAgNDA4IMKg
MjU3MDEyIMKgIMKgMTE5IDIxNzEgwqAxMTggwqAgwqAgMCDCoCDCoCAxMTggwqAgwqAgMSDCoCDC
oCAwIMKgIMKgIMKgMCDCoCA2NTwvZm9udD48L2Rpdj48ZGl2Pjxmb250IGZhY2U9Im1vbm9zcGFj
ZSwgbW9ub3NwYWNlIj4xMjo0NjoyNCBzZGIgwqAgwqAgwqAgwqAgwqAgwqAgMTIgwqAgwqAgwqAw
IMKgIMKgMyDCoCDCoDQgwqAgwqAgNSDCoCDCoDM2MDggwqAgwqAgwqAwIMKgIDIwIMKgMTgwIMKg
IMKgIDAgwqAgwqAgMTU3IMKgIMKgIDEgwqAgwqAgMCDCoCDCoCA0MyDCoDEwMDwvZm9udD48L2Rp
dj48ZGl2Pjxmb250IGZhY2U9Im1vbm9zcGFjZSwgbW9ub3NwYWNlIj4xMjo0NjoyNSBzZGIgwqAg
wqAgwqAgwqAgwqAgwqAgNDQgwqAgwqAgwqAwIMKgIMKgNyDCoCDCoDYgwqAgMjEwIMKgIDc0MDcy
IMKgIMKgIDQxIMKgNjI1IMKgMTE5IMKgIMKgIDAgwqAgwqAgMTE3IMKgIMKgIDEgwqAgwqAgMiDC
oCDCoCDCoDEgwqAgOTc8L2ZvbnQ+PC9kaXY+PGRpdj48Zm9udCBmYWNlPSJtb25vc3BhY2UsIG1v
bm9zcGFjZSI+MTI6NDY6MjYgc2RiIMKgIMKgIMKgIMKgIMKgIMKgIDQ4IMKgIMKgIMKgMCDCoCDC
oDYgwqAgwqA4IMKgIDIxNiDCoDIwMjg1MiDCoCDCoDExMiAxODE5IMKgMTEyIMKgIMKgIDAgwqAg
wqAgMTExIMKgIMKgIDEgwqAgwqAgMCDCoCDCoCDCoDAgwqAgOTI8L2ZvbnQ+PC9kaXY+PGRpdj48
Zm9udCBmYWNlPSJtb25vc3BhY2UsIG1vbm9zcGFjZSI+MTI6NDY6Mjcgc2RiIMKgIMKgIMKgIMKg
IMKgIMKgIDUyIMKgIMKgIMKgMCDCoCDCoDcgwqAgwqA3IMKgIDIzMyDCoDMwNzE1NiDCoCDCoDEz
NyAyNjQ4IMKgMTE2IMKgIMKgIDAgwqAgwqAgMTE1IMKgIMKgIDEgwqAgwqAgMCDCoCDCoCDCoDAg
wqAgOTU8L2ZvbnQ+PC9kaXY+PGRpdj48Zm9udCBmYWNlPSJtb25vc3BhY2UsIG1vbm9zcGFjZSI+
MTI6NDY6Mjggc2RiIMKgIMKgIMKgIMKgIMKgIMKgIDE2IMKgIMKgIMKgMCDCoCDCoDIgwqAgwqA4
IMKgIDEwMCDCoCA5MzE2OCDCoCDCoCDCoDcgwqA2MzggwqAxNDYgwqAgwqAgMCDCoCDCoCAxNDUg
wqAgwqAgMSDCoCDCoCAwIMKgIMKgIMKgMSDCoCA5NzwvZm9udD48L2Rpdj48ZGl2Pjxmb250IGZh
Y2U9Im1vbm9zcGFjZSwgbW9ub3NwYWNlIj4xMjo0NjoyOSBzZGIgwqAgwqAgwqAgwqAgwqAgwqAg
MTYgwqAgwqAgwqAwIMKgIMKgMiDCoCDCoDggwqAgNjQyIMKgIDM3MDI4IMKgIMKgIDE2IMKgMzE5
IMKgMTE2IMKgIMKgIDAgwqAgwqAgMTE1IMKgIMKgIDEgwqAgwqAgNCDCoCDCoCDCoDMgwqAgOTk8
L2ZvbnQ+PC9kaXY+PGRpdj48Zm9udCBmYWNlPSJtb25vc3BhY2UsIG1vbm9zcGFjZSI+MTI6NDY6
MzAgc2RiIMKgIMKgIMKgIMKgIMKgIMKgIDE2IMKgIMKgIMKgMCDCoCDCoDIgwqAgwqA4IMKgIDYy
NCDCoCAzOTA2OCDCoCDCoCAzNiDCoDM0MiDCoDExNCDCoCDCoCAwIMKgIMKgIDExMyDCoCDCoCAx
IMKgIMKgIDMgwqAgwqAgwqAyIMKgIDk5PC9mb250PjwvZGl2PjxkaXY+PGZvbnQgZmFjZT0ibW9u
b3NwYWNlLCBtb25vc3BhY2UiPjEyOjQ2OjMxIHNkYiDCoCDCoCDCoCDCoCDCoCDCoCA4MCDCoCDC
oCDCoDAgwqAgMTAgwqAgwqA4IMKgIMKgOTQgwqAyNTM4OTIgwqAgwqAxMDUgMjE2OSDCoDExNyDC
oCDCoCAwIMKgIMKgIDExNiDCoCDCoCAxIMKgIMKgIDAgwqAgwqAgwqAwIMKgIDg0PC9mb250Pjwv
ZGl2PjxkaXY+PGZvbnQgZmFjZT0ibW9ub3NwYWNlLCBtb25vc3BhY2UiPjEyOjQ2OjMyIHNkYiDC
oCDCoCDCoCDCoCDCoCDCoCDCoDAgwqAgwqAgwqAwIMKgIMKgMCDCoCDCoDAgwqAgwqAgMCDCoCDC
oDU2NzYgwqAgwqAgwqAwIMKgIDMzIMKgMTcyIMKgIMKgIDAgwqAgwqAgMTcyIMKgIMKgIDEgwqAg
wqAgMCDCoCDCoCAzMCDCoDEwMDwvZm9udD48L2Rpdj48ZGl2Pjxmb250IGZhY2U9Im1vbm9zcGFj
ZSwgbW9ub3NwYWNlIj4xMjo0NjozMyBzZGIgwqAgwqAgwqAgwqAgwqAgwqAgMTYgwqAgwqAgwqAw
IMKgIMKgMiDCoCDCoDggwqAgNjQyIMKgIDY5MjM2IMKgIMKgIDI4IMKgNTgzIMKgMTE5IMKgIMKg
IDAgwqAgwqAgMTE4IMKgIMKgIDEgwqAgwqAgMiDCoCDCoCDCoDEgwqAgOTY8L2ZvbnQ+PC9kaXY+
PGRpdj48Zm9udCBmYWNlPSJtb25vc3BhY2UsIG1vbm9zcGFjZSI+MTI6NDY6MzQgc2RiIMKgIMKg
IMKgIMKgIMKgIMKgIMKgOCDCoCDCoCDCoDAgwqAgwqAxIMKgIMKgOCDCoDEwMzIgwqAgMzcxMzIg
wqAgwqAgMzAgwqAzMTUgwqAxMTggwqAgwqAgMCDCoCDCoCAxMTcgwqAgwqAgMSDCoCDCoCAzIMKg
IMKgIMKgMyDCoDEwMDwvZm9udD48L2Rpdj48ZGl2Pjxmb250IGZhY2U9Im1vbm9zcGFjZSwgbW9u
b3NwYWNlIj4xMjo0NjozNSBzZGIgwqAgwqAgwqAgwqAgwqAgwqAgMTYgwqAgwqAgwqAwIMKgIMKg
MiDCoCDCoDggwqAgODIyIMKgIDU2MjkyIMKgIMKgIDE1IMKgNTE1IMKgMTA5IMKgIMKgIDAgwqAg
wqAgMTA4IMKgIMKgIDEgwqAgwqAgMyDCoCDCoCDCoDEgwqAxMDA8L2ZvbnQ+PC9kaXY+PGRpdj48
Zm9udCBmYWNlPSJtb25vc3BhY2UsIG1vbm9zcGFjZSI+PGJyPjwvZm9udD48L2Rpdj48ZGl2Pjxm
b250IGZhY2U9Im1vbm9zcGFjZSwgbW9ub3NwYWNlIj4jIERJU0sgU1RBVElTVElDUyAoL3NlYyk8
L2ZvbnQ+PC9kaXY+PGRpdj48Zm9udCBmYWNlPSJtb25vc3BhY2UsIG1vbm9zcGFjZSI+IyDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCAmbHQ7LS0tLS0tLS0tcmVhZHMtLS0tLS0tLS0tLS0tLS0m
Z3Q7Jmx0Oy0tLS0tLS0tLXdyaXRlcy0tLS0tLS0tLS0tLS0tJmd0OyZsdDstLS0tLS0tLWF2ZXJh
Z2VzLS0tLS0tLS0mZ3Q7IFBjdDwvZm9udD48L2Rpdj48ZGl2Pjxmb250IGZhY2U9Im1vbm9zcGFj
ZSwgbW9ub3NwYWNlIj4jVGltZSDCoCDCoCBOYW1lIMKgIMKgIMKgIEtCeXRlcyBNZXJnZWQgwqBJ
T3MgU2l6ZSDCoFdhaXQgwqBLQnl0ZXMgTWVyZ2VkIMKgSU9zIFNpemUgwqBXYWl0IMKgUldTaXpl
IMKgUUxlbiDCoFdhaXQgU3ZjVGltIFV0aWw8L2ZvbnQ+PC9kaXY+PGRpdj48Zm9udCBmYWNlPSJt
b25vc3BhY2UsIG1vbm9zcGFjZSI+MTI6NDY6MzYgc2RiIMKgIMKgIMKgIMKgIMKgIMKgIMKgOCDC
oCDCoCDCoDAgwqAgwqAxIMKgIMKgOCDCoCDCoDQ0IMKgIDU4NzY4IMKgIMKgIDE1IMKgNDUyIMKg
MTMwIMKgIMKgIDAgwqAgwqAgMTI5IMKgIMKgIDEgwqAgwqAgMCDCoCDCoCDCoDIgwqAgOTY8L2Zv
bnQ+PC9kaXY+PGRpdj48Zm9udCBmYWNlPSJtb25vc3BhY2UsIG1vbm9zcGFjZSI+MTI6NDY6Mzcg
c2RiIMKgIMKgIMKgIMKgIMKgIMKgIDI4IMKgIMKgIMKgMCDCoCDCoDQgwqAgwqA3IMKgIDM5MCDC
oDExNDk0NCDCoCDCoCA4OSAxMTAwIMKgMTA0IMKgIMKgIDAgwqAgwqAgMTA0IMKgIMKgIDEgwqAg
wqAgMSDCoCDCoCDCoDAgwqAgODg8L2ZvbnQ+PC9kaXY+PGRpdj48Zm9udCBmYWNlPSJtb25vc3Bh
Y2UsIG1vbm9zcGFjZSI+MTI6NDY6Mzggc2RiIMKgIMKgIMKgIMKgIMKgIMKgIMKgMCDCoCDCoCDC
oDAgwqAgwqAwIMKgIMKgMCDCoCDCoCAwIMKgIDI5NjY4IMKgIMKgIMKgMCDCoDE3MiDCoDE3MiDC
oCDCoDEyIMKgIMKgIDE3MiDCoCDCoCAxIMKgIMKgMTIgwqAgwqAgwqA1IMKgIDk4PC9mb250Pjwv
ZGl2PjxkaXY+PGZvbnQgZmFjZT0ibW9ub3NwYWNlLCBtb25vc3BhY2UiPjEyOjQ2OjM5IHNkYiDC
oCDCoCDCoCDCoCDCoCDCoCA4MCDCoCDCoCDCoDAgwqAgMTAgwqAgwqA4IMKgIMKgOTAgwqAxMDAw
ODQgwqAgwqAgMzEgwqA4ODIgwqAxMTMgwqAgwqAgMCDCoCDCoCAxMTIgwqAgwqAgMSDCoCDCoCAx
IMKgIMKgIMKgMSDCoCA5MTwvZm9udD48L2Rpdj48ZGl2Pjxmb250IGZhY2U9Im1vbm9zcGFjZSwg
bW9ub3NwYWNlIj4xMjo0Njo0MCBzZGIgwqAgwqAgwqAgwqAgwqAgwqAgwqAwIMKgIMKgIMKgMCDC
oCDCoDAgwqAgwqAwIMKgIMKgIDAgwqAgMjQyNDQgwqAgwqAgwqAwIMKgMTM5IMKgMTc0IMKgIMKg
IDAgwqAgwqAgMTc0IMKgIMKgIDEgwqAgwqAgMCDCoCDCoCDCoDcgwqAxMDA8L2ZvbnQ+PC9kaXY+
PGRpdj48Zm9udCBmYWNlPSJtb25vc3BhY2UsIG1vbm9zcGFjZSI+MTI6NDY6NDEgc2RiIMKgIMKg
IMKgIMKgIMKgIMKgIMKgOCDCoCDCoCDCoDAgwqAgwqAxIMKgIMKgOCDCoDEyMjQgwqAgwqAgwqAg
MCDCoCDCoCDCoDAgwqAgwqAwIMKgIMKgMCDCoCDCoCAwIMKgIMKgIMKgIDggwqAgwqAgMSDCoDEy
MjQgwqAgMTAwMCDCoDEwMDwvZm9udD48L2Rpdj48ZGl2Pjxmb250IGZhY2U9Im1vbm9zcGFjZSwg
bW9ub3NwYWNlIj4xMjo0Njo0MiBzZGIgwqAgwqAgwqAgwqAgwqAgwqAgwqA4IMKgIMKgIMKgMCDC
oCDCoDEgwqAgwqA4IMKgMTI0NCDCoCA0MjM2OCDCoCDCoCAyOSDCoDM1NCDCoDEyMCDCoCDCoCAw
IMKgIMKgIDExOSDCoCDCoCAxIMKgIMKgIDMgwqAgwqAgwqAyIMKgIDk2PC9mb250PjwvZGl2Pjxk
aXY+PGZvbnQgZmFjZT0ibW9ub3NwYWNlLCBtb25vc3BhY2UiPjEyOjQ2OjQzIHNkYiDCoCDCoCDC
oCDCoCDCoCDCoCAzNiDCoCDCoCDCoDAgwqAgwqA1IMKgIMKgNyDCoCAyNTEgwqAgNTE0MjggwqAg
wqAgMzIgwqA1MDcgwqAxMDEgwqAgwqAgMCDCoCDCoCAxMDAgwqAgwqAgMSDCoCDCoCAyIMKgIMKg
IMKgMSDCoCA5NDwvZm9udD48L2Rpdj48ZGl2Pjxmb250IGZhY2U9Im1vbm9zcGFjZSwgbW9ub3Nw
YWNlIj4xMjo0Njo0NCBzZGIgwqAgwqAgwqAgwqAgwqAgwqAgMjQgwqAgwqAgwqAwIMKgIMKgMyDC
oCDCoDggwqAgwqA3MCDCoCDCoDU3MzIgwqAgwqAgMzEgwqAxNDcgwqAgMzkgwqAgwqAxNSDCoCDC
oCDCoDM4IMKgIMKgIDIgwqAgwqAxNiDCoCDCoCDCoDYgwqAgOTk8L2ZvbnQ+PC9kaXY+PGRpdj48
Zm9udCBmYWNlPSJtb25vc3BhY2UsIG1vbm9zcGFjZSI+MTI6NDY6NDUgc2RiIMKgIMKgIMKgIMKg
IMKgIMKgIDMyIMKgIMKgIMKgMCDCoCDCoDQgwqAgwqA4IMKgIMKgIDQgwqAyMTMwNTYgwqAgwqAg
NTMgMTY0NyDCoDEyOSDCoCDCoCAwIMKgIMKgIDEyOSDCoCDCoCAxIMKgIMKgIDAgwqAgwqAgwqAw
IMKgIDc0PC9mb250PjwvZGl2PjxkaXY+PGZvbnQgZmFjZT0ibW9ub3NwYWNlLCBtb25vc3BhY2Ui
PjEyOjQ2OjQ2IHNkYiDCoCDCoCDCoCDCoCDCoCDCoCDCoDggwqAgwqAgwqAwIMKgIMKgMSDCoCDC
oDggwqAxMjIwIMKgIDM3NDE2IMKgIMKgIDI4IMKgMzI4IMKgMTE0IMKgIMKgIDAgwqAgwqAgMTEz
IMKgIMKgIDEgwqAgwqAgMyDCoCDCoCDCoDIgwqAgOTY8L2ZvbnQ+PC9kaXY+PGRpdj48Zm9udCBm
YWNlPSJtb25vc3BhY2UsIG1vbm9zcGFjZSI+MTI6NDY6NDcgc2RiIMKgIMKgIMKgIMKgIMKgIMKg
IMKgOCDCoCDCoCDCoDAgwqAgwqAxIMKgIMKgOCDCoDEyNDggwqAgNTg1NzIgwqAgwqAgNjcgwqA2
MDcgwqAgOTYgwqAgwqAgMCDCoCDCoCDCoDk2IMKgIMKgIDEgwqAgwqAgMiDCoCDCoCDCoDEgwqAg
OTM8L2ZvbnQ+PC9kaXY+PGRpdj48Zm9udCBmYWNlPSJtb25vc3BhY2UsIG1vbm9zcGFjZSI+MTI6
NDY6NDggc2RiIMKgIMKgIMKgIMKgIMKgIMKgIDQwIMKgIMKgIMKgMCDCoCDCoDUgwqAgwqA4IMKg
IMKgODQgwqAyNzQ4MDggwqAgwqAgODIgMjE3MyDCoDEyNiDCoCDCoCAwIMKgIMKgIDEyNiDCoCDC
oCAxIMKgIMKgIDAgwqAgwqAgwqAwIMKgIDcwPC9mb250PjwvZGl2PjxkaXY+PGZvbnQgZmFjZT0i
bW9ub3NwYWNlLCBtb25vc3BhY2UiPjEyOjQ2OjQ5IHNkYiDCoCDCoCDCoCDCoCDCoCDCoCDCoDAg
wqAgwqAgwqAwIMKgIMKgMCDCoCDCoDAgwqAgwqAgMCDCoCDCoCDCoCAwIMKgIMKgIMKgMCDCoCDC
oDAgwqAgwqAwIMKgIMKgIDAgwqAgwqAgwqAgMCDCoCDCoCAxIMKgIMKgIDAgwqAgwqAgwqAwIMKg
MTAwPC9mb250PjwvZGl2PjxkaXY+PGZvbnQgZmFjZT0ibW9ub3NwYWNlLCBtb25vc3BhY2UiPjEy
OjQ2OjUwIHNkYiDCoCDCoCDCoCDCoCDCoCDCoCDCoDggwqAgwqAgwqAwIMKgIMKgMSDCoCDCoDgg
wqAxMjQ4IMKgIMKgIMKgIDAgwqAgwqAgwqAwIMKgIMKgMCDCoCDCoDAgwqAgwqAgMCDCoCDCoCDC
oCA4IMKgIMKgIDEgwqAxMjQ4IMKgIDEwMDAgwqAxMDA8L2ZvbnQ+PC9kaXY+PGRpdj48Zm9udCBm
YWNlPSJtb25vc3BhY2UsIG1vbm9zcGFjZSI+MTI6NDY6NTEgc2RiIMKgIMKgIMKgIMKgIMKgIMKg
IMKgOCDCoCDCoCDCoDAgwqAgwqAxIMKgIMKgOCDCoDEyNzIgwqAgwqAgwqAgMCDCoCDCoCDCoDAg
wqAgwqAwIMKgIMKgMCDCoCDCoCAwIMKgIMKgIMKgIDggwqAgwqAgMSDCoDEyNzIgwqAgMTAwMCDC
oDEwMDwvZm9udD48L2Rpdj48ZGl2Pjxmb250IGZhY2U9Im1vbm9zcGFjZSwgbW9ub3NwYWNlIj4x
Mjo0Njo1MiBzZGIgwqAgwqAgwqAgwqAgwqAgwqAgMjQgwqAgwqAgwqAwIMKgIMKgMyDCoCDCoDgg
wqAgNDE0IMKgMjA1MjQwIMKgIMKgMTEzIDE3OTggwqAxMTQgwqAgwqAgMCDCoCDCoCAxMTMgwqAg
wqAgMSDCoCDCoCAwIMKgIMKgIMKgMCDCoCA3NTwvZm9udD48L2Rpdj48ZGl2Pjxmb250IGZhY2U9
Im1vbm9zcGFjZSwgbW9ub3NwYWNlIj4xMjo0Njo1MyBzZGIgwqAgwqAgwqAgwqAgwqAgwqAgwqA4
IMKgIMKgIMKgMCDCoCDCoDEgwqAgwqA4IMKgIDg3NiDCoCA5MjQ3NiDCoCDCoCA0OCDCoDgzOSDC
oDExMCDCoCDCoCAwIMKgIMKgIDExMCDCoCDCoCAxIMKgIMKgIDEgwqAgwqAgwqAxIMKgIDg5PC9m
b250PjwvZGl2PjxkaXY+PGZvbnQgZmFjZT0ibW9ub3NwYWNlLCBtb25vc3BhY2UiPjEyOjQ2OjU0
IHNkYiDCoCDCoCDCoCDCoCDCoCDCoCDCoDAgwqAgwqAgwqAwIMKgIMKgMCDCoCDCoDAgwqAgwqAg
MCDCoCAzODcwMCDCoCDCoCDCoDAgwqAyMjUgwqAxNzIgwqAgwqAgMCDCoCDCoCAxNzIgwqAgwqAg
MSDCoCDCoCAwIMKgIMKgIMKgNCDCoCA5OTwvZm9udD48L2Rpdj48ZGl2Pjxmb250IGZhY2U9Im1v
bm9zcGFjZSwgbW9ub3NwYWNlIj4xMjo0Njo1NSBzZGIgwqAgwqAgwqAgwqAgwqAgwqAgMTYgwqAg
wqAgwqAwIMKgIMKgMiDCoCDCoDggwqAgNTgyIMKgMTUwNjgwIMKgIMKgIDczIDEyNjIgwqAxMTkg
wqAgwqAgMCDCoCDCoCAxMTkgwqAgwqAgMSDCoCDCoCAxIMKgIMKgIMKgMCDCoCA4NzwvZm9udD48
L2Rpdj48ZGl2Pjxmb250IGZhY2U9Im1vbm9zcGFjZSwgbW9ub3NwYWNlIj4xMjo0Njo1NiBzZGIg
wqAgwqAgwqAgwqAgwqAgwqAgwqA4IMKgIMKgIMKgMCDCoCDCoDEgwqAgwqA4IMKgMTIyOCDCoCDC
oCDCoCAwIMKgIMKgIMKgMCDCoCDCoDAgwqAgwqAwIMKgIMKgIDAgwqAgwqAgwqAgOCDCoCDCoCAx
IMKgMTIyOCDCoCAxMDAwIMKgMTAwPC9mb250PjwvZGl2PjxkaXY+PGZvbnQgZmFjZT0ibW9ub3Nw
YWNlLCBtb25vc3BhY2UiPjEyOjQ2OjU3IHNkYiDCoCDCoCDCoCDCoCDCoCDCoCDCoDggwqAgwqAg
wqAwIMKgIMKgMSDCoCDCoDggwqAxMjQ0IMKgIMKgIMKgIDAgwqAgwqAgwqAwIMKgIMKgMCDCoCDC
oDAgwqAgwqAgMCDCoCDCoCDCoCA4IMKgIMKgIDEgwqAxMjQ0IMKgIDEwMDAgwqAxMDA8L2ZvbnQ+
PC9kaXY+PC9kaXY+PGRpdj48YnI+PC9kaXY+PGRpdj5uZXh0IEkgcGxheWVkIGJhY2sgdGhlIGNv
bGxlY3RsIHByb2Nlc3MgZGF0YSBhbmQgc29ydGVkIGJ5IGRpc2sgcmVhZHMgYW5kIGRpc2NvdmVy
ZWQgdGhlIHRvcCBwcm9jZXNzLCBjb3JyZXNwb25kaW5nIHRvIHRoZSBsb25nIGRpc2sgcmVhZHMg
d2FzIHhmc2FpbGQuIMKgYnR3IC0gSSBhbHNvIHNlZSB0aGUgc2xhYiB4ZnNfaW5vZGUgdXNpbmcg
YWJvdXQgNjBHQi48L2Rpdj48ZGl2Pjxicj48L2Rpdj48ZGl2Pkl0JiMzOTtzIGFsc28gd29ydGgg
bm90aW5nIHRoYXQgSSYjMzk7bSBvbmx5IGRvaW5nIDEtMk1CL3NlYyBvZiB3cml0ZXMgYW5kIHRo
ZSByZXN0IG9mIHRoZSBkYXRhIGxvb2tzIGxpa2UgaXQmIzM5O3MgY29taW5nIGZyb20geGZzIGpv
dXJuYWxpbmcgYmVjYXVzZSB3aGVuIEkgbG9vayBhdCB0aGUgeGZzIHN0YXRzIEkmIzM5O20gc2Vl
aW5nIG9uIHRoZSBvcmRlciBvZiAyMDAtNDAwTUIvc2VjIHhmcyBsb2dnaW5nIHdyaXRlcyAtIGNs
ZWFybHkgdGhleSYjMzk7cmUgbm90IGFsbCBnb2luZyB0byBkaXNrLsKgIE9uY2UgdGhlIHJlYWQg
d2FpdHMgaW5jcmVhc2UgZXZlcnl0aGluZyBzbG93cyBkb3duIGluY2x1ZGluZyB4ZnMgbG9nZ2lu
ZyAoc2luY2UgaXQmIzM5O3MgZG9pbmcgbGVzcykuPC9kaXY+PGRpdj48YnI+PC9kaXY+PGRpdj5J
JiMzOTttIHN1cmUgdGhlIHNpbXBsZSBhbnN3ZXIgbWF5IGJlIHRoYXQgaXQgaXMgd2hhdCBpdCBp
cywgYnV0IEkmIzM5O20gYWxzbyB3b25kZXJpbmcgd2l0aG91dCBjaGFuZ2VzIHRvIHN3aWZ0IGl0
c2VsZiwgbWlnaHQgdGhlcmUgYmUgc29tZSB3YXlzIHRvIGltcHJvdmUgdGhlIHNpdHVhdGlvbiBi
eSBhZGRpbmcgbW9yZSBtZW1vcnkgb3IgbWFraW5nIGFueSBvdGhlciB0dW5pbmcgY2hhbmdlcz/C
oCBUaGUgc3lzdGVtIEkmIzM5O20gY3VycmVudGx5IHJ1bm5pbmcgbXkgdGVzdHMgb24gaGFzIDEy
OEdCLjwvZGl2PjxkaXY+PGJyPjwvZGl2PjxkaXY+LW1hcmvCoDwvZGl2PjxkaXY+PGJyPjwvZGl2
PjxkaXY+PGRpdiBjbGFzcz0iZ21haWxfZXh0cmEiPjxkaXYgY2xhc3M9ImdtYWlsX3F1b3RlIj5P
biBXZWQsIEphbiA2LCAyMDE2IGF0IDY6NDkgUE0sIERhdmUgQ2hpbm5lciA8c3BhbiBkaXI9Imx0
ciI+Jmx0OzxhIGhyZWY9Im1haWx0bzpkYXZpZEBmcm9tb3JiaXQuY29tIiB0YXJnZXQ9Il9ibGFu
ayI+ZGF2aWRAZnJvbW9yYml0LmNvbTwvYT4mZ3Q7PC9zcGFuPiB3cm90ZTo8YnI+PGJsb2NrcXVv
dGUgY2xhc3M9ImdtYWlsX3F1b3RlIiBzdHlsZT0ibWFyZ2luOjBweCAwcHggMHB4IDAuOGV4O2Jv
cmRlci1sZWZ0LXdpZHRoOjFweDtib3JkZXItbGVmdC1jb2xvcjpyZ2IoMjA0LDIwNCwyMDQpO2Jv
cmRlci1sZWZ0LXN0eWxlOnNvbGlkO3BhZGRpbmctbGVmdDoxZXgiPjxzcGFuIGNsYXNzPSIiPk9u
IFdlZCwgSmFuIDA2LCAyMDE2IGF0IDA1OjQ2OjMzUE0gLTA1MDAsIE1hcmsgU2VnZXIgd3JvdGU6
PGJyPg0KJmd0OyBkYXZlLCB0aGFua3MgZm9yIGdldHRpbmcgYmFjayB0byBtZSBhbmQgdGhlIHBv
aW50ZXIgdG8gdGhlIGNvbmZpZyBkb2MuPGJyPg0KJmd0O8KgIGxvdHMgdG8gYWJzb3JiIGFuZCBw
bGF5IHdpdGguPGJyPg0KJmd0Ozxicj4NCiZndDsgdGhlIHJlYWwgY2hhbGxlbmdlIGZvciBtZSBp
cyB0aGF0IEkmIzM5O20gZG9pbmcgdGVzdGluZyBhcyBkaWZmZXJlbnQgbGV2ZWxzLjxicj4NCiZn
dDsgV2hpbGUgaSByZWFsaXplIHJ1bm5pbmcgMTAwIHBhcmFsbGVsIHN3aWZ0IFBVVCB0aHJlYWRz
IG9uIGEgc21hbGwgc3lzdGVtIGlzPGJyPg0KJmd0OyBub3QgdGhlIGlkZWFsIHdheSB0byBkbyB0
aGluZ3MsIGl0JiMzOTtzIHRoZSBvbmx5IGVhc3kgd2F5IHRvIGdldCBtYXNzaXZlPGJyPg0KJmd0
OyBudW1iZXJzIG9mIG9iamVjdHMgaW50byB0aGUgZmlsbGVzeXN0ZW0gYW5kIG9uY2UgdGhlcmUs
IHRoZSBwZXJmb3JtYW5jZSBvZjxicj4NCiZndDsgYSBzaW5nbGUgc3RyZWFtIGlzIHByZXR0eSBw
b29yIGFuZCBieSBpbnN0cnVtZW50aW5nIHRoZSBzd2lmdCBjb2RlIEkgY2FuPGJyPg0KJmd0OyBj
bGVhcmx5IHNlZSBleGNlc3MgdGltZSBiZWluZyBzcGVudCBpbiBjcmVhdGluZy93cml0aW5nIHRo
ZSBvYmplY3RzIGFuZCBzbzxicj4NCiZndDsgdGhhdCYjMzk7cyBsZWFkIHVzIHRvIGJlbGlldmUg
dGhlIHByb2JsZW0gbGllcyBpbiB0aGUgd2F5IHhmcyBpcyBjb25maWd1cmVkLjxicj4NCiZndDvC
oCBjcmVhdGluZyBhIG5ldyBkaXJlY3Rvcnkgc3RydWN0dXJlIG9uIHRoYXQgc2FtZSBtb3VudCBw
b2ludCBpbW1lZGlhdGVseTxicj4NCiZndDsgcmVzdWx0cyBpbiBoaWdoIGxldmVscyBvZiBwZXJm
b3JtYW5jZS48YnI+DQomZ3Q7PGJyPg0KJmd0OyBBcyBhbiBhdHRlbXB0IHRvIHRyeSB0byByZXBy
b2R1Y2UgdGhlIHByb2JsZW1zIHcvbyBzd2lmdCwgSSB3cm90ZSBhIGxpdHRsZTxicj4NCiZndDsg
cHl0aG9uIHNjcmlwdCB0aGF0IHNpbXBseSBjcmVhdGVzIGZpbGVzIGluIGEgMi10aWVyIHN0cnVj
dHVyZSwgdGhlIGZpcnN0PGJyPg0KJmd0OyB0aWVyIGNvbnNpc3Rpbmcgb2YgMTAyNCBkaXJlY3Rv
cmllcyBhbmQgZWFjaCBkaXJlY3RvcnkgY29udGFpbnMgNDA5Njxicj4NCiZndDsgc3ViZGlyZWN0
b3JpZXMgaW50byB3aGljaCAxSyBmaWxlcyBhcmUgY3JlYXRlZC48YnI+DQo8YnI+DQo8L3NwYW4+
U28geW91IGNyZWF0ZWQgc29tZXRoaW5nIHdpdGggZXZlbiBncmVhdGVyIGZhbi1vdXQgdGhhbiB3
aGF0IHlvdXI8YnI+DQpzd2lmdCBhcHAgaXMgdXNpbmc/PGJyPg0KPGRpdj48ZGl2IGNsYXNzPSJo
NSI+PGJyPg0KJmd0OyBJJiMzOTttIGRvaW5nIHRoaXMgZm9yIDEwMDAwPGJyPg0KJmd0OyBvYmpl
Y3RzIGFzIGEgdGltZSBhbmQgdGhlbiB0aW1pbmcgdGhlbSwgcmVwb3J0aW5nIHRoZSB0aW1lcywg
MTAgcGVyIGxpbmUgc288YnI+DQomZ3Q7IGVhY2ggbGluZSByZXByZXNlbnRzIDEwMCB0aG91c2Fu
ZCBmaWxlIGNyZWF0ZXMuPGJyPg0KJmd0Ozxicj4NCiZndDsgSGVyZSB0b28gSSYjMzk7bSBzZWVp
bmcgZGVncmFkYXRpb24gYW5kIGlmIEkgbG9vayBhdCB3aGF0IGhhcHBlbnMgd2hlbiB0aGVyZTxi
cj4NCiZndDsgYXJlIGFscmVhZHkgM00gZmlsZXMgYW5kIEkgd3JpdGUgMU0gbW9yZSwgSSBzZWUg
dGhlc2UgY3JlYXRpb24gdGltZXMvMTA8YnI+DQomZ3Q7IHRob3VzYW5kOjxicj4NCiZndDs8YnI+
DQomZ3Q7wqAgMS4wMDQyMzbCoCAwLjk2MTQxOcKgIDAuOTk2NTE0wqAgMS4wMTIxNTDCoCAxLjEw
MTc5NMKgIDAuOTk5NDIywqAgMC45OTQ3OTY8YnI+DQomZ3Q7wqAgMS4yMTQ1MzXCoCAwLjk5NzI3
NsKgIDEuMzA2NzM2PGJyPg0KJmd0O8KgIDIuNzkzNDI5wqAgMS4yMDE0NzHCoCAxLjEzMzU3NsKg
IDEuMDY5NjgywqAgMS4wMzA5ODXCoCAxLjA5NjM0McKgIDEuMDUyNjAyPGJyPg0KJmd0O8KgIDEu
MzkxMzY0wqAgMC45OTk0ODDCoCAxLjkxNDEyNTxicj4NCiZndDvCoCAxLjE5Mzg5MsKgIDAuOTY3
MjA2wqAgMS4yNjMzMTDCoCAwLjg5MDQ3MsKgIDEuMDUxOTYywqAgNC4yNTM2OTTCoCAxLjE0NTU3
Mzxicj4NCiZndDvCoCAxLjUyODg0OCAxMy41ODY4OTLCoCA0LjkyNTc5MDxicj4NCiZndDvCoCAz
Ljk3NTQ0MsKgIDguODk2NTUywqAgMS4xOTcwMDXCoCAzLjkwNDIyNsKgIDcuNTAzODA2wqAgMS4y
OTQ4NDLCoCAxLjgxNjQyMjxicj4NCiZndDvCoCA5LjMyOTc5MsKgIDcuMjcwMzIzwqAgNS45MzY1
NDU8YnI+DQomZ3Q7wqAgNy4wNTg2ODXCoCA1LjUxNjg0McKgIDQuNTI3MjcxwqAgMS45NTY1OTLC
oCAxLjM4MjU1McKgIDEuNTEwMzM5wqAgMS4zMTgzNDE8YnI+DQomZ3Q7IDEzLjI1NTkzOcKgIDYu
OTM4ODQ1wqAgNC4xMDYwNjY8YnI+DQomZ3Q7wqAgMi42MTIwNjTCoCAyLjAyODc5NcKgIDQuNjQ3
OTgwwqAgNy4zNzE2MjjCoCA1LjQ3MzQyM8KgIDUuODIzMjAxIDE0LjIyOTEyMDxicj4NCiZndDvC
oCAwLjg5OTM0OMKgIDMuNTM5NjU4wqAgOC41MDE0OTg8YnI+DQomZ3Q7wqAgNC42NjI1OTPCoCA2
LjQyMzUzMMKgIDcuOTgwNzU3wqAgNi4zNjcwMTLCoCAzLjQxNDIzOcKgIDcuMzY0ODU3wqAgNC4x
NDM3NTE8YnI+DQomZ3Q7wqAgNi4zMTczNDggMTEuMzkzMDY3wqAgMS4yNzMzNzE8YnI+DQomZ3Q7
IDE0Ni4wNjczMDDCoCAxLjMxNzgxNMKgIDEuMTc2NTI5wqAgMS4xNzc4MzAgNTIuMjA2NjA1wqAg
MS4xMTI4NTTCoCAyLjA4Nzk5MDxicj4NCiZndDsgNDIuMzI4MjIwwqAgMS4xNzg0MzbCoCAxLjMz
NTIwMjxicj4NCiZndDsgNDkuMTE4MTQwwqAgMS4zNjg2OTbCoCAxLjUxNTgyNiA0NC42OTA0MzHC
oCAwLjkyNzQyOMKgIDAuOTIwODAxwqAgMC45ODU5NjU8YnI+DQomZ3Q7wqAgMS4wMDA1OTHCoCAx
LjAyNzQ1OCA2MC42NTA0NDM8YnI+DQomZ3Q7wqAgMS43NzEzMTjCoCAyLjY5MDQ5OcKgIDIuMjYy
ODY4wqAgMS4wNjEzNDPCoCAwLjkzMjk5OCA2NC4wNjQyMTAgMzcuNzI2MjEzPGJyPg0KJmd0O8Kg
IDEuMjQ1MTI5wqAgMC43NDM3NzHCoCAwLjk5NjY4Mzxicj4NCiZndDs8YnI+DQomZ3Q7IG5vdGhp
bmcgb25lIHNldCBvZiAxMEsgdG9vayBhbG1vc3QgMyBtaW51dGVzITxicj4NCjxicj4NCjwvZGl2
PjwvZGl2PldoaWNoIGlzIG5vIHN1cnByaXNlIGJlY2F1c2UgeW91IGhhdmUgc2xvdyBkaXNrcyBh
bmQgYSAqbG90KiBvZjxicj4NCm1lbW9yeS4gQXQgc29tZSBwb2ludCB0aGUgam91cm5hbCBhbmQv
b3IgbWVtb3J5IGlzIGdvaW5nIHRvIGZpbGwgdXA8YnI+DQp3aXRoIGRpcnR5IG9iamVjdHMgYW5k
IGhhdmUgdG8gYmxvY2sgd2FpdGluZyBmb3Igd3JpdGViYWNrLiBBdCB0aGF0PGJyPg0KcG9pbnQg
dGhlcmUmIzM5O3MgZ29pbmcgdG8gYmUgc2V2ZXJhbCBodW5kcmVkIHRob3VzYW5kIGRpcnR5IGlu
b2RlcyB0aGF0PGJyPg0KbmVlZCB0byBiZSBmbHVzaGVkIHRvIGRpc2sgYmVmb3JlIHByb2dyZXNz
IGNhbiBiZSBtYWRlIGFnYWluLsKgIFRoYXQ8YnI+DQptZXRhZGF0YSB3cml0ZWJhY2sgd2lsbCBi
ZSBzZWVrIGJvdW5kLCBhbmQgdGhhdCYjMzk7cyB3aGVyZSBhbGwgdGhlPGJyPg0KZGVsYXkgY29t
ZXMgZnJvbS48YnI+DQo8YnI+DQpXZSYjMzk7dmUgYmVlbiB0aHJvdWdoIHRoaXMgcHJvYmxlbSBz
ZXZlcmFsIHRpbWVzIG5vdyB3aXRoIGRpZmZlcmVudDxicj4NCnN3aWZ0IHVzZXJzIG92ZXIgdGhl
IHBhc3QgY291cGxlIG9mIHllYXJzLiBQbGVhc2UgZ28gYW5kIHNlYXJjaCB0aGU8YnI+DQpsaXN0
IGFyY2hpdmVzLCBiZWNhdXNlIGV2ZXJ5IHRpbWUgdGhlIHNvbHV0aW9uIGhhcyBiZWVuIHRoZSBz
YW1lOjxicj4NCjxicj4NCsKgIMKgIMKgIMKgIC0gcmVkdWNlIHRoZSBkaXJlY3RvcnkgaGVpcmFy
Y2h5IHRvIGEgc2luZ2xlIGxldmVsIHdpdGgsIGF0PGJyPg0KwqAgwqAgwqAgwqAgwqAgbW9zdCwg
dGhlIG51bWJlciBvZiBkaXJlY3RvcmllcyBtYXRjaGluZyB0aGUgZXhwZWN0ZWQ8YnI+DQrCoCDC
oCDCoCDCoCDCoCAqcHJvZHVjdGlvbiogY29uY3VycmVuY3kgbGV2ZWw8YnI+DQrCoCDCoCDCoCDC
oCAtIHJlZHVjZSB0aGUgWEZTIGxvZyBzaXplIGRvd24gdG8gMzItMTI4TUIgdG8gbGltaXQgZGly
dHk8YnI+DQrCoCDCoCDCoCDCoCDCoCBtZXRhZGF0YSBvYmplY3QgYnVpbGR1cCBpbiBtZW1vcnk8
YnI+DQrCoCDCoCDCoCDCoCAtIHJlZHVjZSB0aGUgbnVtYmVyIG9mIEFHcyB0byBhcyBzbWFsbCBh
cyBuZWNlc3NhcnkgdG88YnI+DQrCoCDCoCDCoCDCoCDCoCBtYWludGFpbiAvYWxsb2NhdGlvbi8g
Y29uY3VycmVuY3kgdG8gbGltaXQgdGhlIG51bWJlciBvZjxicj4NCsKgIMKgIMKgIMKgIMKgIGRp
ZmZlcmVudCBsb2NhdGlvbnMgWEZTIHdyaXRlcyB0byB0aGUgZGlza3MgKHR5cGljYWxseTxicj4N
CsKgIMKgIMKgIMKgIMKgIDEwLTIweCBsZXNzIHRoYW4gdGhlIGFwcGxpY2F0aW9uIGxldmVsIGNv
bmN1cnJlbmN5KTxicj4NCsKgIMKgIMKgIMKgIC0gdXNlIGEgMy4xNisga2VybmVsIHdpdGggdGhl
IGZyZWUgaW5vZGUgYnRyZWUgb24tZGlzazxicj4NCsKgIMKgIMKgIMKgIMKgIGZvcm1hdCBmZWF0
dXJlIHRvIGtlZXAgaW5vZGUgYWxsb2NhdGlvbiBDUFUgb3ZlcmhlYWQgbG93PGJyPg0KwqAgwqAg
wqAgwqAgwqAgYW5kIGNvbnNpc3RlbnQgcmVnYXJkbGVzcyBvZiB0aGUgbnVtYmVyIG9mIGlub2Rl
cyBhbHJlYWR5PGJyPg0KwqAgwqAgwqAgwqAgwqAgYWxsb2NhdGVkIGluIHRoZSBmaWxlc3lzdGVt
Ljxicj4NCjxzcGFuIGNsYXNzPSIiPjxicj4NCiZndDsgbXkgbWFpbiBxdWVzdGlvbnMgYXQgdGhp
cyBwb2ludCBhcmUgaXMgdGhpcyBwZXJmb3JtYW5jZSBleHBlY3RlZCBhbmQvb3I8YnI+DQomZ3Q7
IG1pZ2h0IGEgbmV3ZXIga2VybmVsIGhlbHA/wqAgYW5kIG1pZ2h0IGl0IGJlIHBvc3NpYmxlIHRv
IHNpZ25pZmljYW50bHk8YnI+DQomZ3Q7IGltcHJvdmUgdGhpbmdzIHZpYSB0dW5pbmcgb3IgaXMg
aXQgd2hhdCBpdCBpcz/CoCBJIGRvIHJlYWxpemUgSSYjMzk7bSBzdGFydGluZzxicj4NCiZndDsg
d2l0aCBhbiBlbXB0eSBkaXJlY3RvcnkgdHJlZSB3aG9zZSBwZXJmb3JtYW5jZSBkZWdyYWRlcyBh
cyBpdCBmaWxscywgYnV0IGlmPGJyPg0KJmd0OyBJIHdhbnRlZCB0byB0dW5lIGZvciBzYXkgMTBN
IG9yIG1heWJlIDEwME0gZmlsZXMgbWlnaHQgSSBiZSBhYmxlIHRvIGV4cGVjdDxicj4NCjxicj4N
Cjwvc3Bhbj5UaGUgbWtmcyBkZWZhdWx0cyB3aWxsIHdvcmsganVzdCBmaW5lIHdpdGggdGhhdCBt
YW55IGZpbGVzIGluIHRoZTxicj4NCmZpbGVzeXN0ZW0uIFlvdXIgYXBwbGljYXRpb24gY29uZmln
dXJhdGlvbiBhbmQgZGF0YSBzdG9yZSBsYXlvdXQgaXM8YnI+DQpsaWtlbHkgdG8gYmUgeW91ciBi
aWdnZXN0IHByb2JsZW0gaGVyZS48YnI+DQo8ZGl2IGNsYXNzPSIiPjxkaXYgY2xhc3M9Img1Ij48
YnI+DQpDaGVlcnMsPGJyPg0KPGJyPg0KRGF2ZS48YnI+DQo8YnI+DQotLTxicj4NCkRhdmUgQ2hp
bm5lcjxicj4NCjxhIGhyZWY9Im1haWx0bzpkYXZpZEBmcm9tb3JiaXQuY29tIj5kYXZpZEBmcm9t
b3JiaXQuY29tPC9hPjxicj4NCjwvZGl2PjwvZGl2PjwvYmxvY2txdW90ZT48L2Rpdj48YnI+PC9k
aXY+PC9kaXY+PC9kaXY+DQo=
--047d7b5d457e95b6bc052a2b31af--


--===============7506839264880572252==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7506839264880572252==--
