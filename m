Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D2EEE7F59
	for <xfs@oss.sgi.com>; Sun,  8 Sep 2013 21:35:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 54125AC002
	for <xfs@oss.sgi.com>; Sun,  8 Sep 2013 19:35:06 -0700 (PDT)
Received: from mail-ye0-f178.google.com (mail-ye0-f178.google.com
	[209.85.213.178]) by cuda.sgi.com with ESMTP id
	FWwrLHNqpl2zTBrt (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 08 Sep 2013 19:35:04 -0700 (PDT)
Received: by mail-ye0-f178.google.com with SMTP id m5so1843158yen.23
	for <xfs@oss.sgi.com>; Sun, 08 Sep 2013 19:35:04 -0700 (PDT)
Message-ID: <522D33D0.7030901@gmail.com>
Date: Sun, 08 Sep 2013 22:34:56 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
MIME-Version: 1.0
Subject: Better numbers Re: [RFC PATCH 10/11] xfs: update the finobt on inode
	free
References: <1378232708-57156-1-git-send-email-bfoster@redhat.com>
	<1378232708-57156-11-git-send-email-bfoster@redhat.com>
	<20130905025421.GX23571@dastard> <5228AF00.7080700@redhat.com>
	<20130906002847.GR12779@dastard> <5229BEE6.3060407@redhat.com>
	<20130906212441.GB12541@dastard> <522B1C4F.7000404@redhat.com>
In-Reply-To: <522B1C4F.7000404@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On 09/07/2013 08:30 AM, Brian Foster wrote:
> On 09/06/2013 05:24 PM, Dave Chinner wrote:
>> On Fri, Sep 06, 2013 at 07:39:18AM -0400, Brian Foster wrote:
>>> On 09/05/2013 08:28 PM, Dave Chinner wrote:
>>>> On Thu, Sep 05, 2013 at 12:19:12PM -0400, Brian Foster wrote:
>>>>> On 09/04/2013 10:54 PM, Dave Chinner wrote:
>>>>>> On Tue, Sep 03, 2013 at 02:25:07PM -0400, Brian Foster wrote:
>>> ...
>>>>>
> ...
>>>> No worries. BTW, can you post your rudimentary userspace support so
>>>> we can run tests that use this code, too?
>>>>
>>>
>>> Sure. My xfsprogs branch currently is the application of a slightly
>>> older version of this set (pre-cleanups I made to make this post-worthy)
>>> with some hacks to make it apply/compile and a few other patches on top
>>> of that for mkfs, xfs_db and xfs_repair to work through some basic
>>> things I ran into when running xfstests.
>>>
>>> Would you prefer I drop the whole thing on the list?
>>
>> Drop it on the list, maybe just a as tarball rather than a patchset
>> if it's not ready for review yet.
>>
> 
> Ok, attached. This applies on top of the following commit in the
> xfsprogs tree:
> 
> 982e5c7e xfs_db: add header to freesp -d output
> 
> Use the following command to format a finobt enabled fs:
> 
> mkfs.xfs -m crc=1,finobt=1 <dev>
> 
> ... and otherwise there are a couple random fixes for xfs_db and xfs_repair.
> 
> Brian
> 
> 
>> Cheers,
>>
>> Dave.

Hi!  Here's a better set of numbers, using the finobt-enabled userspace. 
Some cosmetic errors in my chart-generating Perl script were also fixed.

Revised legend:

v4: v4 XFS
v4dirent: v4 with Mark's dirent patches
v4d512bi: same as above, with 512-byte inodes
v5: v5/CRC XFS, no finobt except for "finobt" patch case

Again, a kernel git dir was built, then turned into a source tar.gz 
file for these tests.

Files involved in find/sha256/cp/stat tests:
$TEST_DIR/a/linux/ (kernel + xfs-oss/master, built)
$TEST_DIR/b/linux/ (same)

                         REAL
command     patch     v4    v4dirent v4d512bi    v5
----------+-------+--------+--------+--------+--------
tar -xf    normal   103.202  104.951  101.771  104.486
tar -xf    patched  104.610  101.705   98.784  101.919
tar -xf    finobt   103.753  102.949  102.609   99.847
----------+-------+--------+--------+--------+--------
sha256sum  normal   227.456  228.321  231.947  234.127
sha256sum  patched  230.233  229.375  231.509  233.253
sha256sum  finobt   228.108  228.873  232.464  233.498
----------+-------+--------+--------+--------+--------
cp -r a b  normal   239.714  242.754  248.994  249.584
cp -r a b  patched  241.273  243.216  248.531  254.501
cp -r a b  finobt   240.779  242.838  244.760  253.203
----------+-------+--------+--------+--------+--------
find .     normal    11.894   12.370   12.324   12.397
find .     patched   12.043   12.310   12.736   13.216
find .     finobt    11.882   12.376   13.501   13.827
----------+-------+--------+--------+--------+--------
rm -r a    normal     8.556    8.744   11.298   11.774
rm -r a    patched    8.904    8.981   10.590   12.057
rm -r a    finobt     8.588    9.007   10.841   12.168
----------+-------+--------+--------+--------+--------
cp -r b a  normal   262.065  256.448  272.290  272.221
cp -r b a  patched  264.116  265.875  267.346  270.811
cp -r b a  finobt   265.255  259.111  262.312  268.700
----------+-------+--------+--------+--------+--------
rm -r b    normal     8.585    9.258    8.791   10.058
rm -r b    patched    9.061    8.345    9.909    9.273
rm -r b    finobt     8.326    8.231   10.078   10.464
----------+-------+--------+--------+--------+--------
stat       normal   161.853  162.772  163.555  165.046
stat       patched  162.641  163.148  163.698  164.015
stat       finobt   163.366  162.707  163.256  165.051
----------+-------+--------+--------+--------+--------
sha check  normal   133.938  133.016  141.352  142.921
sha check  patched  133.885  133.399  138.013  143.315
sha check  finobt   135.128  134.900  142.158  141.094
----------+-------+--------+--------+--------+--------
cp tarball normal    44.102   42.812   43.603   43.722
cp tarball patched   43.724   44.187   44.339   42.761
cp tarball finobt    43.930   43.236   42.736   44.000
----------+-------+--------+--------+--------+--------
TOTAL      normal  1201.365 1201.446 1235.925 1246.336
TOTAL      patched 1210.490 1210.541 1225.455 1245.121
TOTAL      finobt  1209.115 1204.228 1224.715 1241.852

                         USER
command     patch     v4    v4dirent v4d512bi    v5
----------+-------+--------+--------+--------+--------
tar -xf    normal    59.223   59.473   58.817   59.640
tar -xf    patched   59.420   59.473   58.953   59.893
tar -xf    finobt    59.153   59.850   59.643   59.153
----------+-------+--------+--------+--------+--------
sha256sum  normal    49.877   49.877   49.787   49.730
sha256sum  patched   49.437   49.863   49.583   49.673
sha256sum  finobt    49.577   49.580   49.743   49.597
----------+-------+--------+--------+--------+--------
cp -r a b  normal     0.697    0.707    0.743    0.800
cp -r a b  patched    0.657    0.710    0.677    0.703
cp -r a b  finobt     0.737    0.777    0.777    0.780
----------+-------+--------+--------+--------+--------
find .     normal     0.257    0.237    0.233    0.223
find .     patched    0.283    0.223    0.223    0.203
find .     finobt     0.263    0.253    0.237    0.273
----------+-------+--------+--------+--------+--------
rm -r a    normal     0.170    0.120    0.147    0.160
rm -r a    patched    0.160    0.163    0.130    0.137
rm -r a    finobt     0.173    0.157    0.123    0.150
----------+-------+--------+--------+--------+--------
cp -r b a  normal     0.817    0.763    0.817    0.763
cp -r b a  patched    0.737    0.740    0.787    0.670
cp -r b a  finobt     0.783    0.747    0.737    0.687
----------+-------+--------+--------+--------+--------
rm -r b    normal     0.170    0.153    0.140    0.133
rm -r b    patched    0.140    0.157    0.143    0.163
rm -r b    finobt     0.173    0.127    0.193    0.153
----------+-------+--------+--------+--------+--------
stat       normal     1.660    1.653    1.570    1.720
stat       patched    1.737    1.727    1.700    1.630
stat       finobt     1.767    1.640    1.557    1.763
----------+-------+--------+--------+--------+--------
sha check  normal    58.467   58.603   58.550   58.370
sha check  patched   58.157   58.183   58.620   58.343
sha check  finobt    58.530   58.107   58.367   58.300
----------+-------+--------+--------+--------+--------
cp tarball normal     0.023    0.027    0.033    0.037
cp tarball patched    0.017    0.020    0.020    0.020
cp tarball finobt     0.020    0.037    0.033    0.020
----------+-------+--------+--------+--------+--------
TOTAL      normal   171.361  171.613  170.837  171.576
TOTAL      patched  170.745  171.259  170.836  171.435
TOTAL      finobt   171.176  171.275  171.410  170.876

                         SYS
command     patch     v4    v4dirent v4d512bi    v5
----------+-------+--------+--------+--------+--------
tar -xf    normal    19.770   19.800   19.960   20.770
tar -xf    patched   19.550   19.930   20.067   20.963
tar -xf    finobt    20.010   19.707   19.707   21.397
----------+-------+--------+--------+--------+--------
sha256sum  normal    17.157   14.607   14.393   16.053
sha256sum  patched   17.277   14.813   14.550   15.007
sha256sum  finobt    17.123   14.920   14.667   15.133
----------+-------+--------+--------+--------+--------
cp -r a b  normal    18.697   18.973   18.687   19.253
cp -r a b  patched   19.033   18.993   18.783   19.703
cp -r a b  finobt    19.093   18.863   18.877   19.363
----------+-------+--------+--------+--------+--------
find .     normal     0.820    0.573    0.537    0.597
find .     patched    0.793    0.593    0.547    0.610
find .     finobt     0.800    0.553    0.533    0.543
----------+-------+--------+--------+--------+--------
rm -r a    normal     3.883    3.827    3.800    3.967
rm -r a    patched    4.053    3.937    4.003    4.143
rm -r a    finobt     4.010    4.020    3.983    4.290
----------+-------+--------+--------+--------+--------
cp -r b a  normal    19.043   19.083   18.753   19.503
cp -r b a  patched   19.203   19.100   19.040   19.680
cp -r b a  finobt    19.133   18.973   18.950   19.607
----------+-------+--------+--------+--------+--------
rm -r b    normal     4.097    3.947    3.900    4.123
rm -r b    patched    4.287    4.067    4.093    4.227
rm -r b    finobt     4.223    4.140    4.013    4.480
----------+-------+--------+--------+--------+--------
stat       normal    11.337   10.730   10.727   10.680
stat       patched   11.080   10.827   10.800   10.457
stat       finobt    11.393   10.720   10.680   10.797
----------+-------+--------+--------+--------+--------
sha check  normal     8.970    8.920    8.980    9.507
sha check  patched    9.053    9.143    8.540    9.420
sha check  finobt     8.653    9.020    8.863    9.103
----------+-------+--------+--------+--------+--------
cp tarball normal     5.537    5.397    5.470    5.373
cp tarball patched    5.390    5.313    5.460    5.343
cp tarball finobt     5.520    5.357    5.333    5.603
----------+-------+--------+--------+--------+--------
TOTAL      normal   109.311  105.857  105.207  109.826
TOTAL      patched  109.719  106.716  105.883  109.553
TOTAL      finobt   109.958  106.273  105.606  110.316

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
