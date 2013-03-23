Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [150.166.39.100])
	by oss.sgi.com (Postfix) with ESMTP id 5BDC97F74
	for <xfs@oss.sgi.com>; Sat, 23 Mar 2013 05:24:18 -0500 (CDT)
Date: Sat, 23 Mar 2013 03:24:16 -0700
From: Phil White <pwhite@sgi.com>
Subject: Re: [PATCH 20/25] xfstests: introduce a common directory
Message-ID: <20130323102415.GX25253@caliban.engr.sgi.com>
References: <1363350489-22257-1-git-send-email-david@fromorbit.com>
	<1363350489-22257-21-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1363350489-22257-21-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Looks OK.

Reviewed-by: Phil White <pwhite@sgi.com>

On Fri, Mar 15, 2013 at 11:28:04PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Introduce a top level common directory and move all the common.*
> files into it.  Because there is now a directory named common, the
> prefix can be dropped from all the files. Convert all the tests to
> use this new directory for including common files.
> 
> for f in common.*; do \
> 	git mv `echo -n "$f " ; echo $f | sed -e 's;n\.;n/;'` \
> done
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  check                                    |   10 +++++-----
>  common.attr => common/attr               |    0
>  common.config => common/config           |    0
>  common.defrag => common/defrag           |    0
>  common.dmapi => common/dmapi             |    0
>  common.dump => common/dump               |    0
>  common.filestreams => common/filestreams |    0
>  common.filter => common/filter           |    0
>  btrfs.filter => common/filter.btrfs      |    0
>  common.log => common/log                 |    0
>  common.punch => common/punch             |    2 +-
>  common.quota => common/quota             |    0
>  common.rc => common/rc                   |    2 +-
>  common.repair => common/repair           |    0
>  common.scsi_debug => common/scsi_debug   |    0
>  tests/btrfs/254                          |    4 ++--
>  tests/btrfs/264                          |    4 ++--
>  tests/btrfs/265                          |    4 ++--
>  tests/btrfs/276                          |    4 ++--
>  tests/btrfs/284                          |    6 +++---
>  tests/btrfs/313                          |    4 ++--
>  tests/ext4/271                           |    4 ++--
>  tests/ext4/301                           |    6 +++---
>  tests/ext4/302                           |    6 +++---
>  tests/ext4/303                           |    6 +++---
>  tests/ext4/304                           |    6 +++---
>  tests/generic/001                        |    4 ++--
>  tests/generic/002                        |    4 ++--
>  tests/generic/005                        |    4 ++--
>  tests/generic/006                        |    4 ++--
>  tests/generic/007                        |    4 ++--
>  tests/generic/010                        |    4 ++--
>  tests/generic/011                        |    4 ++--
>  tests/generic/013                        |    4 ++--
>  tests/generic/014                        |    4 ++--
>  tests/generic/015                        |    4 ++--
>  tests/generic/020                        |    6 +++---
>  tests/generic/053                        |    6 +++---
>  tests/generic/062                        |    6 +++---
>  tests/generic/068                        |    4 ++--
>  tests/generic/069                        |    4 ++--
>  tests/generic/070                        |    6 +++---
>  tests/generic/074                        |    4 ++--
>  tests/generic/075                        |    4 ++--
>  tests/generic/076                        |    4 ++--
>  tests/generic/077                        |    6 +++---
>  tests/generic/079                        |    6 +++---
>  tests/generic/083                        |    4 ++--
>  tests/generic/088                        |    4 ++--
>  tests/generic/089                        |    4 ++--
>  tests/generic/091                        |    4 ++--
>  tests/generic/093                        |    6 +++---
>  tests/generic/097                        |    4 ++--
>  tests/generic/099                        |    6 +++---
>  tests/generic/100                        |    6 +++---
>  tests/generic/105                        |    6 +++---
>  tests/generic/112                        |    4 ++--
>  tests/generic/113                        |    4 ++--
>  tests/generic/117                        |    6 +++---
>  tests/generic/120                        |    4 ++--
>  tests/generic/123                        |    4 ++--
>  tests/generic/124                        |    4 ++--
>  tests/generic/125                        |    4 ++--
>  tests/generic/126                        |    4 ++--
>  tests/generic/127                        |    4 ++--
>  tests/generic/128                        |    4 ++--
>  tests/generic/129                        |    4 ++--
>  tests/generic/130                        |    4 ++--
>  tests/generic/131                        |    4 ++--
>  tests/generic/132                        |    4 ++--
>  tests/generic/133                        |    4 ++--
>  tests/generic/135                        |    4 ++--
>  tests/generic/141                        |    4 ++--
>  tests/generic/169                        |    4 ++--
>  tests/generic/184                        |    4 ++--
>  tests/generic/192                        |    4 ++--
>  tests/generic/193                        |    4 ++--
>  tests/generic/198                        |    4 ++--
>  tests/generic/204                        |    4 ++--
>  tests/generic/207                        |    4 ++--
>  tests/generic/208                        |    4 ++--
>  tests/generic/209                        |    4 ++--
>  tests/generic/210                        |    4 ++--
>  tests/generic/211                        |    4 ++--
>  tests/generic/212                        |    4 ++--
>  tests/generic/213                        |    4 ++--
>  tests/generic/214                        |    4 ++--
>  tests/generic/215                        |    4 ++--
>  tests/generic/219                        |    6 +++---
>  tests/generic/221                        |    2 +-
>  tests/generic/223                        |    4 ++--
>  tests/generic/224                        |    4 ++--
>  tests/generic/225                        |    4 ++--
>  tests/generic/226                        |    2 +-
>  tests/generic/228                        |    2 +-
>  tests/generic/230                        |    6 +++---
>  tests/generic/231                        |    6 +++---
>  tests/generic/232                        |    6 +++---
>  tests/generic/233                        |    6 +++---
>  tests/generic/234                        |    6 +++---
>  tests/generic/235                        |    6 +++---
>  tests/generic/236                        |    2 +-
>  tests/generic/237                        |    6 +++---
>  tests/generic/239                        |    4 ++--
>  tests/generic/240                        |    4 ++--
>  tests/generic/241                        |    4 ++--
>  tests/generic/245                        |    4 ++--
>  tests/generic/246                        |    4 ++--
>  tests/generic/247                        |    4 ++--
>  tests/generic/248                        |    4 ++--
>  tests/generic/249                        |    4 ++--
>  tests/generic/251                        |    4 ++--
>  tests/generic/255                        |    6 +++---
>  tests/generic/256                        |    6 +++---
>  tests/generic/257                        |    4 ++--
>  tests/generic/258                        |    2 +-
>  tests/generic/260                        |    4 ++--
>  tests/generic/263                        |    4 ++--
>  tests/generic/269                        |    4 ++--
>  tests/generic/270                        |    6 +++---
>  tests/generic/273                        |    4 ++--
>  tests/generic/274                        |    4 ++--
>  tests/generic/275                        |    4 ++--
>  tests/generic/277                        |    4 ++--
>  tests/generic/280                        |    6 +++---
>  tests/generic/285                        |    4 ++--
>  tests/generic/286                        |    4 ++--
>  tests/generic/288                        |    4 ++--
>  tests/generic/294                        |    4 ++--
>  tests/generic/299                        |    4 ++--
>  tests/generic/300                        |    4 ++--
>  tests/shared/051                         |    6 +++---
>  tests/shared/218                         |    6 +++---
>  tests/shared/243                         |    4 ++--
>  tests/shared/272                         |    4 ++--
>  tests/shared/289                         |    4 ++--
>  tests/shared/298                         |    4 ++--
>  tests/shared/305                         |    6 +++---
>  tests/udf/098                            |    4 ++--
>  tests/udf/101                            |    4 ++--
>  tests/udf/102                            |    4 ++--
>  tests/xfs/003                            |    4 ++--
>  tests/xfs/004                            |    4 ++--
>  tests/xfs/008                            |    4 ++--
>  tests/xfs/009                            |    4 ++--
>  tests/xfs/012                            |    4 ++--
>  tests/xfs/016                            |    4 ++--
>  tests/xfs/017                            |    4 ++--
>  tests/xfs/018                            |    6 +++---
>  tests/xfs/019                            |    4 ++--
>  tests/xfs/021                            |    6 +++---
>  tests/xfs/022                            |    4 ++--
>  tests/xfs/023                            |    4 ++--
>  tests/xfs/024                            |    4 ++--
>  tests/xfs/025                            |    4 ++--
>  tests/xfs/026                            |    4 ++--
>  tests/xfs/027                            |    4 ++--
>  tests/xfs/028                            |    4 ++--
>  tests/xfs/029                            |    4 ++--
>  tests/xfs/030                            |    6 +++---
>  tests/xfs/031                            |    6 +++---
>  tests/xfs/032                            |    4 ++--
>  tests/xfs/033                            |    6 +++---
>  tests/xfs/034                            |    4 ++--
>  tests/xfs/035                            |    4 ++--
>  tests/xfs/036                            |    4 ++--
>  tests/xfs/037                            |    4 ++--
>  tests/xfs/038                            |    4 ++--
>  tests/xfs/039                            |    4 ++--
>  tests/xfs/040                            |    4 ++--
>  tests/xfs/041                            |    4 ++--
>  tests/xfs/042                            |    4 ++--
>  tests/xfs/043                            |    4 ++--
>  tests/xfs/044                            |    4 ++--
>  tests/xfs/045                            |    4 ++--
>  tests/xfs/046                            |    4 ++--
>  tests/xfs/047                            |    4 ++--
>  tests/xfs/048                            |    4 ++--
>  tests/xfs/049                            |    4 ++--
>  tests/xfs/050                            |    6 +++---
>  tests/xfs/052                            |    6 +++---
>  tests/xfs/054                            |    6 +++---
>  tests/xfs/055                            |    4 ++--
>  tests/xfs/056                            |    4 ++--
>  tests/xfs/057                            |    4 ++--
>  tests/xfs/058                            |    4 ++--
>  tests/xfs/059                            |    4 ++--
>  tests/xfs/060                            |    4 ++--
>  tests/xfs/061                            |    4 ++--
>  tests/xfs/063                            |    8 ++++----
>  tests/xfs/064                            |    6 +++---
>  tests/xfs/065                            |    6 +++---
>  tests/xfs/066                            |    6 +++---
>  tests/xfs/067                            |    6 +++---
>  tests/xfs/071                            |    4 ++--
>  tests/xfs/072                            |    4 ++--
>  tests/xfs/073                            |    4 ++--
>  tests/xfs/078                            |    4 ++--
>  tests/xfs/080                            |    4 ++--
>  tests/xfs/081                            |    8 ++++----
>  tests/xfs/082                            |    6 +++---
>  tests/xfs/084                            |    4 ++--
>  tests/xfs/085                            |    6 +++---
>  tests/xfs/086                            |    6 +++---
>  tests/xfs/087                            |    8 ++++----
>  tests/xfs/090                            |    4 ++--
>  tests/xfs/092                            |    4 ++--
>  tests/xfs/094                            |    4 ++--
>  tests/xfs/095                            |    6 +++---
>  tests/xfs/096                            |    6 +++---
>  tests/xfs/103                            |    4 ++--
>  tests/xfs/104                            |    4 ++--
>  tests/xfs/106                            |    6 +++---
>  tests/xfs/107                            |    6 +++---
>  tests/xfs/108                            |    6 +++---
>  tests/xfs/109                            |    4 ++--
>  tests/xfs/110                            |    4 ++--
>  tests/xfs/111                            |    4 ++--
>  tests/xfs/114                            |    6 +++---
>  tests/xfs/115                            |    6 +++---
>  tests/xfs/116                            |    6 +++---
>  tests/xfs/118                            |    6 +++---
>  tests/xfs/119                            |    4 ++--
>  tests/xfs/121                            |    6 +++---
>  tests/xfs/122                            |    2 +-
>  tests/xfs/134                            |    6 +++---
>  tests/xfs/136                            |    6 +++---
>  tests/xfs/137                            |    4 ++--
>  tests/xfs/138                            |    4 ++--
>  tests/xfs/139                            |    4 ++--
>  tests/xfs/140                            |    4 ++--
>  tests/xfs/142                            |    6 +++---
>  tests/xfs/143                            |    6 +++---
>  tests/xfs/144                            |    6 +++---
>  tests/xfs/145                            |    6 +++---
>  tests/xfs/146                            |    6 +++---
>  tests/xfs/147                            |    6 +++---
>  tests/xfs/148                            |    6 +++---
>  tests/xfs/149                            |    6 +++---
>  tests/xfs/150                            |    6 +++---
>  tests/xfs/151                            |    6 +++---
>  tests/xfs/152                            |    6 +++---
>  tests/xfs/153                            |    6 +++---
>  tests/xfs/154                            |    6 +++---
>  tests/xfs/155                            |    6 +++---
>  tests/xfs/156                            |    6 +++---
>  tests/xfs/157                            |    6 +++---
>  tests/xfs/158                            |    6 +++---
>  tests/xfs/159                            |    6 +++---
>  tests/xfs/160                            |    6 +++---
>  tests/xfs/161                            |    6 +++---
>  tests/xfs/162                            |    6 +++---
>  tests/xfs/163                            |    6 +++---
>  tests/xfs/164                            |    4 ++--
>  tests/xfs/165                            |    4 ++--
>  tests/xfs/166                            |    4 ++--
>  tests/xfs/167                            |    4 ++--
>  tests/xfs/168                            |    6 +++---
>  tests/xfs/170                            |    6 +++---
>  tests/xfs/171                            |    6 +++---
>  tests/xfs/172                            |    6 +++---
>  tests/xfs/173                            |    6 +++---
>  tests/xfs/174                            |    6 +++---
>  tests/xfs/175                            |    8 ++++----
>  tests/xfs/176                            |    8 ++++----
>  tests/xfs/177                            |    6 +++---
>  tests/xfs/178                            |    6 +++---
>  tests/xfs/179                            |    4 ++--
>  tests/xfs/180                            |    4 ++--
>  tests/xfs/181                            |    6 +++---
>  tests/xfs/182                            |    4 ++--
>  tests/xfs/183                            |    4 ++--
>  tests/xfs/185                            |    6 +++---
>  tests/xfs/186                            |    6 +++---
>  tests/xfs/187                            |    6 +++---
>  tests/xfs/188                            |    4 ++--
>  tests/xfs/189                            |    4 ++--
>  tests/xfs/190                            |    4 ++--
>  tests/xfs/191                            |    4 ++--
>  tests/xfs/194                            |    4 ++--
>  tests/xfs/195                            |    4 ++--
>  tests/xfs/196                            |    6 +++---
>  tests/xfs/197                            |    4 ++--
>  tests/xfs/199                            |    4 ++--
>  tests/xfs/200                            |    4 ++--
>  tests/xfs/201                            |    4 ++--
>  tests/xfs/202                            |    6 +++---
>  tests/xfs/203                            |    4 ++--
>  tests/xfs/205                            |    4 ++--
>  tests/xfs/206                            |    4 ++--
>  tests/xfs/216                            |    4 ++--
>  tests/xfs/217                            |    4 ++--
>  tests/xfs/220                            |    6 +++---
>  tests/xfs/222                            |    4 ++--
>  tests/xfs/227                            |    4 ++--
>  tests/xfs/229                            |    2 +-
>  tests/xfs/238                            |    4 ++--
>  tests/xfs/242                            |    6 +++---
>  tests/xfs/244                            |    6 +++---
>  tests/xfs/250                            |    4 ++--
>  tests/xfs/252                            |    6 +++---
>  tests/xfs/253                            |    4 ++--
>  tests/xfs/259                            |    2 +-
>  tests/xfs/261                            |    6 +++---
>  tests/xfs/262                            |    6 +++---
>  tests/xfs/266                            |    4 ++--
>  tests/xfs/267                            |    6 +++---
>  tests/xfs/268                            |    6 +++---
>  tests/xfs/278                            |    4 ++--
>  tests/xfs/279                            |    6 +++---
>  tests/xfs/281                            |    4 ++--
>  tests/xfs/282                            |    4 ++--
>  tests/xfs/283                            |    4 ++--
>  tests/xfs/287                            |    4 ++--
>  tests/xfs/290                            |    4 ++--
>  tests/xfs/291                            |    4 ++--
>  tests/xfs/292                            |    4 ++--
>  tests/xfs/293                            |    4 ++--
>  tests/xfs/295                            |    4 ++--
>  tests/xfs/296                            |    6 +++---
>  tests/xfs/297                            |    4 ++--
>  321 files changed, 725 insertions(+), 725 deletions(-)
>  rename common.attr => common/attr (100%)
>  rename common.config => common/config (100%)
>  rename common.defrag => common/defrag (100%)
>  rename common.dmapi => common/dmapi (100%)
>  rename common.dump => common/dump (100%)
>  rename common.filestreams => common/filestreams (100%)
>  rename common.filter => common/filter (100%)
>  rename btrfs.filter => common/filter.btrfs (100%)
>  rename common.log => common/log (100%)
>  rename common.punch => common/punch (99%)
>  rename common.quota => common/quota (100%)
>  rename common.rc => common/rc (99%)
>  rename common.repair => common/repair (100%)
>  rename common.scsi_debug => common/scsi_debug (100%)
> 
> diff --git a/check b/check
> index af6d317..cc426db 100755
> --- a/check
> +++ b/check
> @@ -133,9 +133,9 @@ fi
>  export FSTYP
>  
>  # we need common.config
> -if ! . ./common.config
> +if ! . ./common/config
>  then
> -    echo "$iam: failed to source common.config"
> +    echo "$iam: failed to source common/config"
>      exit 1
>  fi
>  
> @@ -266,10 +266,10 @@ then
>      list=`echo $list | awk -f randomize.awk`
>  fi
>  
> -# we need common.rc
> -if ! . ./common.rc
> +# we need common/rc
> +if ! . ./common/rc
>  then
> -    echo "check: failed to source common.rc"
> +    echo "check: failed to source common/rc"
>      exit 1
>  fi
>  
> diff --git a/common.attr b/common/attr
> similarity index 100%
> rename from common.attr
> rename to common/attr
> diff --git a/common.config b/common/config
> similarity index 100%
> rename from common.config
> rename to common/config
> diff --git a/common.defrag b/common/defrag
> similarity index 100%
> rename from common.defrag
> rename to common/defrag
> diff --git a/common.dmapi b/common/dmapi
> similarity index 100%
> rename from common.dmapi
> rename to common/dmapi
> diff --git a/common.dump b/common/dump
> similarity index 100%
> rename from common.dump
> rename to common/dump
> diff --git a/common.filestreams b/common/filestreams
> similarity index 100%
> rename from common.filestreams
> rename to common/filestreams
> diff --git a/common.filter b/common/filter
> similarity index 100%
> rename from common.filter
> rename to common/filter
> diff --git a/btrfs.filter b/common/filter.btrfs
> similarity index 100%
> rename from btrfs.filter
> rename to common/filter.btrfs
> diff --git a/common.log b/common/log
> similarity index 100%
> rename from common.log
> rename to common/log
> diff --git a/common.punch b/common/punch
> similarity index 99%
> rename from common.punch
> rename to common/punch
> index 7337298..cfbe576 100644
> --- a/common.punch
> +++ b/common/punch
> @@ -19,7 +19,7 @@
>  # common functions for excersizing hole punches with extent size hints etc.
>  
>  # source dmap_scratch_mount etc.
> -. ./common.dmapi
> +. ./common/dmapi
>  
>  _spawn_test_file() {
>  	echo "# spawning test file with $*"
> diff --git a/common.quota b/common/quota
> similarity index 100%
> rename from common.quota
> rename to common/quota
> diff --git a/common.rc b/common/rc
> similarity index 99%
> rename from common.rc
> rename to common/rc
> index 78dbda8..3aa8742 100644
> --- a/common.rc
> +++ b/common/rc
> @@ -154,7 +154,7 @@ _fsck_opts()
>  # we need common.config
>  if [ "$iam" != "check" ]
>  then
> -    if ! . ./common.config
> +    if ! . ./common/config
>          then
>          echo "$iam: failed to source common.config"
>          exit 1
> diff --git a/common.repair b/common/repair
> similarity index 100%
> rename from common.repair
> rename to common/repair
> diff --git a/common.scsi_debug b/common/scsi_debug
> similarity index 100%
> rename from common.scsi_debug
> rename to common/scsi_debug
> diff --git a/tests/btrfs/254 b/tests/btrfs/254
> index ec3d2c5..c98120a 100755
> --- a/tests/btrfs/254
> +++ b/tests/btrfs/254
> @@ -38,8 +38,8 @@ _cleanup()
>  trap "_cleanup ; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs btrfs
> diff --git a/tests/btrfs/264 b/tests/btrfs/264
> index 46a4926..631c744 100755
> --- a/tests/btrfs/264
> +++ b/tests/btrfs/264
> @@ -38,8 +38,8 @@ _cleanup()
>  trap "_cleanup ; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  _need_to_be_root
>  _supported_fs btrfs
> diff --git a/tests/btrfs/265 b/tests/btrfs/265
> index 760f383..7a33cba 100755
> --- a/tests/btrfs/265
> +++ b/tests/btrfs/265
> @@ -42,8 +42,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  _need_to_be_root
>  _supported_fs btrfs
> diff --git a/tests/btrfs/276 b/tests/btrfs/276
> index 2b34fa8..884152a 100755
> --- a/tests/btrfs/276
> +++ b/tests/btrfs/276
> @@ -42,8 +42,8 @@ _cleanup()
>  trap "_cleanup; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _need_to_be_root
> diff --git a/tests/btrfs/284 b/tests/btrfs/284
> index 24b831a..d3ea567 100644
> --- a/tests/btrfs/284
> +++ b/tests/btrfs/284
> @@ -124,9 +124,9 @@ _rundefrag()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.defrag
> +. ./common/rc
> +. ./common/filter
> +. ./common/defrag
>  
>  # real QA test starts here
>  _supported_fs btrfs
> diff --git a/tests/btrfs/313 b/tests/btrfs/313
> index 7b790ee..60fea68 100755
> --- a/tests/btrfs/313
> +++ b/tests/btrfs/313
> @@ -38,8 +38,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./btrfs.filter
> +. ./common/rc
> +. ./common/filter.btrfs
>  
>  # real QA test starts here
>  
> diff --git a/tests/ext4/271 b/tests/ext4/271
> index 6a0e7b1..dfb1ec9 100755
> --- a/tests/ext4/271
> +++ b/tests/ext4/271
> @@ -32,8 +32,8 @@ status=1	# failure is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs ext4
> diff --git a/tests/ext4/301 b/tests/ext4/301
> index 9da867f..b6c2f11 100644
> --- a/tests/ext4/301
> +++ b/tests/ext4/301
> @@ -32,9 +32,9 @@ status=1	# failure is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.defrag
> +. ./common/rc
> +. ./common/filter
> +. ./common/defrag
>  
>  # real QA test starts here
>  _supported_os Linux
> diff --git a/tests/ext4/302 b/tests/ext4/302
> index cb8ffba..9307ab4 100644
> --- a/tests/ext4/302
> +++ b/tests/ext4/302
> @@ -33,9 +33,9 @@ status=1	# failure is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.defrag
> +. ./common/rc
> +. ./common/filter
> +. ./common/defrag
>  
>  # real QA test starts here
>  _supported_os Linux
> diff --git a/tests/ext4/303 b/tests/ext4/303
> index f9eb8c7..84d8f7b 100644
> --- a/tests/ext4/303
> +++ b/tests/ext4/303
> @@ -33,9 +33,9 @@ status=1	# failure is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.defrag
> +. ./common/rc
> +. ./common/filter
> +. ./common/defrag
>  
>  # real QA test starts here
>  _supported_os Linux
> diff --git a/tests/ext4/304 b/tests/ext4/304
> index ca4b849..7b90f1d 100644
> --- a/tests/ext4/304
> +++ b/tests/ext4/304
> @@ -34,9 +34,9 @@ status=1	# failure is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.defrag
> +. ./common/rc
> +. ./common/filter
> +. ./common/defrag
>  
>  # real QA test starts here
>  _supported_os Linux
> diff --git a/tests/generic/001 b/tests/generic/001
> index a6659ab..35c88f2 100755
> --- a/tests/generic/001
> +++ b/tests/generic/001
> @@ -36,8 +36,8 @@ seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  tmp=/tmp/$$
>  here=`pwd`
> diff --git a/tests/generic/002 b/tests/generic/002
> index ba1a5cf..2aeebb1 100755
> --- a/tests/generic/002
> +++ b/tests/generic/002
> @@ -27,8 +27,8 @@ seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  tmp=/tmp/$$
>  here=`pwd`
> diff --git a/tests/generic/005 b/tests/generic/005
> index ba28502..de68b0d 100755
> --- a/tests/generic/005
> +++ b/tests/generic/005
> @@ -62,8 +62,8 @@ _touch()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs generic
> diff --git a/tests/generic/006 b/tests/generic/006
> index 9949d84..62cc0c8 100755
> --- a/tests/generic/006
> +++ b/tests/generic/006
> @@ -49,8 +49,8 @@ _count()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs generic
> diff --git a/tests/generic/007 b/tests/generic/007
> index 2d026a3..4947da6 100755
> --- a/tests/generic/007
> +++ b/tests/generic/007
> @@ -43,8 +43,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs generic
> diff --git a/tests/generic/010 b/tests/generic/010
> index 3587f21..d338db6 100755
> --- a/tests/generic/010
> +++ b/tests/generic/010
> @@ -49,8 +49,8 @@ _filter_dbtest()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  [ -x $here/src/dbtest ] || _notrun "dbtest was not built for this platform"
>  
> diff --git a/tests/generic/011 b/tests/generic/011
> index e5c6bbf..cad09ed 100755
> --- a/tests/generic/011
> +++ b/tests/generic/011
> @@ -41,8 +41,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs generic
> diff --git a/tests/generic/013 b/tests/generic/013
> index 984ed09..a9c07c4 100755
> --- a/tests/generic/013
> +++ b/tests/generic/013
> @@ -51,8 +51,8 @@ _filesize()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  _do_test()
>  {
> diff --git a/tests/generic/014 b/tests/generic/014
> index 096e4e5..d7da9ab 100755
> --- a/tests/generic/014
> +++ b/tests/generic/014
> @@ -40,8 +40,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  _supported_fs generic
>  _supported_os IRIX Linux
> diff --git a/tests/generic/015 b/tests/generic/015
> index a77d2f7..8d3fd5f 100755
> --- a/tests/generic/015
> +++ b/tests/generic/015
> @@ -31,8 +31,8 @@ tmp=/tmp/$$
>  status=1	# success is the default!
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  _cleanup()
>  {
> diff --git a/tests/generic/020 b/tests/generic/020
> index 42465d8..f166009 100755
> --- a/tests/generic/020
> +++ b/tests/generic/020
> @@ -32,9 +32,9 @@ status=0	# success is the default!
>  trap "_cleanup; rm -f $tmp.* $testfile; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.attr
> +. ./common/rc
> +. ./common/filter
> +. ./common/attr
>  
>  _cleanup()
>  {
> diff --git a/tests/generic/053 b/tests/generic/053
> index 99dd1b0..b8bd9e6 100755
> --- a/tests/generic/053
> +++ b/tests/generic/053
> @@ -32,9 +32,9 @@ status=1	# failure is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.attr
> +. ./common/rc
> +. ./common/filter
> +. ./common/attr
>  
>  # real QA test starts here
>  _supported_fs generic
> diff --git a/tests/generic/062 b/tests/generic/062
> index 27907a9..9189a84 100755
> --- a/tests/generic/062
> +++ b/tests/generic/062
> @@ -32,9 +32,9 @@ tmp=/tmp/$$
>  status=1	# failure is the default!
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.attr
> +. ./common/rc
> +. ./common/filter
> +. ./common/attr
>  
>  _cleanup()
>  {
> diff --git a/tests/generic/068 b/tests/generic/068
> index fa71cfc..1a58f5b 100755
> --- a/tests/generic/068
> +++ b/tests/generic/068
> @@ -46,8 +46,8 @@ trap "_cleanup" 0 1 2 3 15
>  
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs generic
> diff --git a/tests/generic/069 b/tests/generic/069
> index b2b18a9..c3fa862 100755
> --- a/tests/generic/069
> +++ b/tests/generic/069
> @@ -32,8 +32,8 @@ status=0	# success is the default!
>  trap "rm -rf $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs generic
> diff --git a/tests/generic/070 b/tests/generic/070
> index a1c5bf5..ad9031e 100755
> --- a/tests/generic/070
> +++ b/tests/generic/070
> @@ -39,9 +39,9 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.attr
> +. ./common/rc
> +. ./common/filter
> +. ./common/attr
>  
>  # real QA test starts here
>  _supported_fs generic
> diff --git a/tests/generic/074 b/tests/generic/074
> index c795dc7..6df8c57 100755
> --- a/tests/generic/074
> +++ b/tests/generic/074
> @@ -39,8 +39,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  _do_test()
>  {
> diff --git a/tests/generic/075 b/tests/generic/075
> index 8012cc1..52e6a43 100755
> --- a/tests/generic/075
> +++ b/tests/generic/075
> @@ -39,8 +39,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  _do_test()
>  {
> diff --git a/tests/generic/076 b/tests/generic/076
> index a1847fc..a53840f 100755
> --- a/tests/generic/076
> +++ b/tests/generic/076
> @@ -48,8 +48,8 @@ _cleanup()
>  trap "_cleanup; rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs generic
> diff --git a/tests/generic/077 b/tests/generic/077
> index 3113119..172ce6e 100755
> --- a/tests/generic/077
> +++ b/tests/generic/077
> @@ -41,9 +41,9 @@ _cleanup()
>  trap "_cleanup; rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.attr
> +. ./common/rc
> +. ./common/filter
> +. ./common/attr
>  
>  # real QA test starts here
>  _supported_fs generic
> diff --git a/tests/generic/079 b/tests/generic/079
> index 3faf106..a533484 100755
> --- a/tests/generic/079
> +++ b/tests/generic/079
> @@ -41,9 +41,9 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.attr
> +. ./common/rc
> +. ./common/filter
> +. ./common/attr
>  
>  _supported_fs generic
>  _supported_os Linux
> diff --git a/tests/generic/083 b/tests/generic/083
> index 12d90f9..dfa44d0 100755
> --- a/tests/generic/083
> +++ b/tests/generic/083
> @@ -49,8 +49,8 @@ _cleanup()
>  trap "_cleanup; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs generic
> diff --git a/tests/generic/088 b/tests/generic/088
> index 1158b46..fce6489 100755
> --- a/tests/generic/088
> +++ b/tests/generic/088
> @@ -34,8 +34,8 @@ status=1	# failure is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  _filter()
>  {
> diff --git a/tests/generic/089 b/tests/generic/089
> index 5e8210d..c4c76e2 100755
> --- a/tests/generic/089
> +++ b/tests/generic/089
> @@ -34,8 +34,8 @@ status=1	# failure is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  addentries()
>  {
> diff --git a/tests/generic/091 b/tests/generic/091
> index 755281e..cee012d 100755
> --- a/tests/generic/091
> +++ b/tests/generic/091
> @@ -32,8 +32,8 @@ status=1	# failure is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs generic
> diff --git a/tests/generic/093 b/tests/generic/093
> index 12ef580..a8ef52e 100755
> --- a/tests/generic/093
> +++ b/tests/generic/093
> @@ -35,9 +35,9 @@ status=1	# FAILure is the default!
>  trap "_cleanup; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.attr
> +. ./common/rc
> +. ./common/filter
> +. ./common/attr
>  
>  _cleanup()
>  {
> diff --git a/tests/generic/097 b/tests/generic/097
> index 510477b..af3e25d 100755
> --- a/tests/generic/097
> +++ b/tests/generic/097
> @@ -59,8 +59,8 @@ _umount_and_mount()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # link correct .out file
>  # This is done bacause udf and xfs print attrs in different orders.
> diff --git a/tests/generic/099 b/tests/generic/099
> index 6efa7a7..0fd28ad 100755
> --- a/tests/generic/099
> +++ b/tests/generic/099
> @@ -33,9 +33,9 @@ status=1	# failure is the default!
>  trap "_cleanup; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.attr
> +. ./common/rc
> +. ./common/filter
> +. ./common/attr
>  
>  runas=$here/src/runas
>  
> diff --git a/tests/generic/100 b/tests/generic/100
> index 34cfde7..123dc5f 100755
> --- a/tests/generic/100
> +++ b/tests/generic/100
> @@ -33,8 +33,8 @@ status=1	# failure is the default!
>  trap "_cleanup; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  _cleanup()
>  {
> @@ -45,7 +45,7 @@ _cleanup()
>  _supported_fs generic
>  _supported_os IRIX Linux
>  
> -# Use _populate_fs() in common.rc to create a directory structure.
> +# Use _populate_fs() in common/rc to create a directory structure.
>  TEMP_DIR=/tmp
>  [ "$FSTYP" == "xfs" ] && TEMP_DIR=$TEST_DIR
>  TAR_FILE=temp.tar
> diff --git a/tests/generic/105 b/tests/generic/105
> index d5b2cb2..2f99401 100755
> --- a/tests/generic/105
> +++ b/tests/generic/105
> @@ -40,9 +40,9 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.attr
> +. ./common/rc
> +. ./common/filter
> +. ./common/attr
>  
>  # Modify as appropriate.
>  _supported_fs generic
> diff --git a/tests/generic/112 b/tests/generic/112
> index 8959c8b..5f5b19d 100755
> --- a/tests/generic/112
> +++ b/tests/generic/112
> @@ -39,8 +39,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  _do_test()
>  {
> diff --git a/tests/generic/113 b/tests/generic/113
> index b2a7317..3b33f96 100755
> --- a/tests/generic/113
> +++ b/tests/generic/113
> @@ -39,8 +39,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  _do_test()
>  {
> diff --git a/tests/generic/117 b/tests/generic/117
> index 624bfd8..87e6987 100755
> --- a/tests/generic/117
> +++ b/tests/generic/117
> @@ -71,9 +71,9 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.attr
> +. ./common/rc
> +. ./common/filter
> +. ./common/attr
>  
>  # real QA test starts here
>  _supported_fs generic
> diff --git a/tests/generic/120 b/tests/generic/120
> index c3069f1..425fab1 100755
> --- a/tests/generic/120
> +++ b/tests/generic/120
> @@ -32,8 +32,8 @@ status=1	# failure is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs generic
> diff --git a/tests/generic/123 b/tests/generic/123
> index 2387676..0f5cc52 100755
> --- a/tests/generic/123
> +++ b/tests/generic/123
> @@ -42,8 +42,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs generic
> diff --git a/tests/generic/124 b/tests/generic/124
> index 65c94b4..92e7619 100755
> --- a/tests/generic/124
> +++ b/tests/generic/124
> @@ -42,8 +42,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs generic
> diff --git a/tests/generic/125 b/tests/generic/125
> index f489e96..18f5cb1 100755
> --- a/tests/generic/125
> +++ b/tests/generic/125
> @@ -37,8 +37,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs generic
> diff --git a/tests/generic/126 b/tests/generic/126
> index 83671df..7fe5bc6 100755
> --- a/tests/generic/126
> +++ b/tests/generic/126
> @@ -38,8 +38,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs generic
> diff --git a/tests/generic/127 b/tests/generic/127
> index 021a571..4aec379 100755
> --- a/tests/generic/127
> +++ b/tests/generic/127
> @@ -42,8 +42,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  FSX_FILE_SIZE=262144
>  FSX_ARGS="-q -l $FSX_FILE_SIZE -o 65536 -S 191110531 -N 100000"
> diff --git a/tests/generic/128 b/tests/generic/128
> index 165aa00..c9c809f 100755
> --- a/tests/generic/128
> +++ b/tests/generic/128
> @@ -38,8 +38,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs generic
> diff --git a/tests/generic/129 b/tests/generic/129
> index e74098f..fe763df 100755
> --- a/tests/generic/129
> +++ b/tests/generic/129
> @@ -38,8 +38,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  echo_and_run()
>  {
> diff --git a/tests/generic/130 b/tests/generic/130
> index 96491f7..6870606 100755
> --- a/tests/generic/130
> +++ b/tests/generic/130
> @@ -47,8 +47,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs generic
> diff --git a/tests/generic/131 b/tests/generic/131
> index 02835ab..95eb612 100755
> --- a/tests/generic/131
> +++ b/tests/generic/131
> @@ -39,8 +39,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs generic
> diff --git a/tests/generic/132 b/tests/generic/132
> index 2abfccf..28c8b9a 100755
> --- a/tests/generic/132
> +++ b/tests/generic/132
> @@ -39,8 +39,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs generic
> diff --git a/tests/generic/133 b/tests/generic/133
> index 478419c..ba386dc 100755
> --- a/tests/generic/133
> +++ b/tests/generic/133
> @@ -37,8 +37,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs generic
> diff --git a/tests/generic/135 b/tests/generic/135
> index b5854f4..1b83465 100755
> --- a/tests/generic/135
> +++ b/tests/generic/135
> @@ -38,8 +38,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs generic
> diff --git a/tests/generic/141 b/tests/generic/141
> index cb7aae2..39400de 100755
> --- a/tests/generic/141
> +++ b/tests/generic/141
> @@ -37,8 +37,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs generic
> diff --git a/tests/generic/169 b/tests/generic/169
> index 6293654..0a07053 100755
> --- a/tests/generic/169
> +++ b/tests/generic/169
> @@ -48,8 +48,8 @@ _show_wrote_and_stat_only()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs generic
> diff --git a/tests/generic/184 b/tests/generic/184
> index 929e0eb..5d74fa3 100755
> --- a/tests/generic/184
> +++ b/tests/generic/184
> @@ -39,8 +39,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs generic
> diff --git a/tests/generic/192 b/tests/generic/192
> index 4b9d0bb..66d8a66 100755
> --- a/tests/generic/192
> +++ b/tests/generic/192
> @@ -39,8 +39,8 @@ _access_time()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  
> diff --git a/tests/generic/193 b/tests/generic/193
> index 8b3b9db..58d1bc6 100755
> --- a/tests/generic/193
> +++ b/tests/generic/193
> @@ -58,8 +58,8 @@ _cleanup_files()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs generic
> diff --git a/tests/generic/198 b/tests/generic/198
> index 5aac37f..5190d34 100755
> --- a/tests/generic/198
> +++ b/tests/generic/198
> @@ -38,8 +38,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  _supported_fs generic
>  _supported_os Linux
> diff --git a/tests/generic/204 b/tests/generic/204
> index ae87930..62bd248 100755
> --- a/tests/generic/204
> +++ b/tests/generic/204
> @@ -30,8 +30,8 @@ tmp=/tmp/$$
>  status=1	# failure is the default!
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs generic
> diff --git a/tests/generic/207 b/tests/generic/207
> index b520bee..0709061 100755
> --- a/tests/generic/207
> +++ b/tests/generic/207
> @@ -37,8 +37,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  
> diff --git a/tests/generic/208 b/tests/generic/208
> index 4c34e7b..badd522 100755
> --- a/tests/generic/208
> +++ b/tests/generic/208
> @@ -37,8 +37,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  
> diff --git a/tests/generic/209 b/tests/generic/209
> index 82d5e6a..2abafcf 100755
> --- a/tests/generic/209
> +++ b/tests/generic/209
> @@ -37,8 +37,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  
> diff --git a/tests/generic/210 b/tests/generic/210
> index 16908cc..ebeb137 100755
> --- a/tests/generic/210
> +++ b/tests/generic/210
> @@ -37,8 +37,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  
> diff --git a/tests/generic/211 b/tests/generic/211
> index 6d7b996..d1110f5 100755
> --- a/tests/generic/211
> +++ b/tests/generic/211
> @@ -37,8 +37,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  
> diff --git a/tests/generic/212 b/tests/generic/212
> index 6e86e94..23ceae0 100755
> --- a/tests/generic/212
> +++ b/tests/generic/212
> @@ -38,8 +38,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  
> diff --git a/tests/generic/213 b/tests/generic/213
> index 1fa573c..a0bfd16 100755
> --- a/tests/generic/213
> +++ b/tests/generic/213
> @@ -41,8 +41,8 @@ status=1	# failure is the default!
>  trap "_cleanup; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  # generic, but xfs_io's fallocate must work
> diff --git a/tests/generic/214 b/tests/generic/214
> index bcd75f8..a19fb59 100755
> --- a/tests/generic/214
> +++ b/tests/generic/214
> @@ -39,8 +39,8 @@ status=1	# failure is the default!
>  trap "_cleanup; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  # generic, but xfs_io's fallocate must work
> diff --git a/tests/generic/215 b/tests/generic/215
> index 73cdd14..6e75645 100755
> --- a/tests/generic/215
> +++ b/tests/generic/215
> @@ -39,8 +39,8 @@ status=1	# failure is the default!
>  trap "_cleanup; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs generic
> diff --git a/tests/generic/219 b/tests/generic/219
> index b71d13d..071d798 100755
> --- a/tests/generic/219
> +++ b/tests/generic/219
> @@ -35,9 +35,9 @@ status=1	# failure is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.quota
> +. ./common/rc
> +. ./common/filter
> +. ./common/quota
>  
>  # real QA test starts here
>  _supported_fs generic
> diff --git a/tests/generic/221 b/tests/generic/221
> index 7fca5bb..e7d4740 100755
> --- a/tests/generic/221
> +++ b/tests/generic/221
> @@ -34,7 +34,7 @@ tmp=/tmp/$$
>  status=1	# failure is the default!
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> +. ./common/rc
>  
>  # real QA test starts here
>  _supported_fs generic
> diff --git a/tests/generic/223 b/tests/generic/223
> index a6932da..416a14a 100755
> --- a/tests/generic/223
> +++ b/tests/generic/223
> @@ -38,8 +38,8 @@ _cleanup()
>  trap "_cleanup ; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs generic
> diff --git a/tests/generic/224 b/tests/generic/224
> index 313d9c2..391d877 100755
> --- a/tests/generic/224
> +++ b/tests/generic/224
> @@ -44,8 +44,8 @@ _cleanup()
>  trap "_cleanup ; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs generic
> diff --git a/tests/generic/225 b/tests/generic/225
> index ea44f2e..9311571 100755
> --- a/tests/generic/225
> +++ b/tests/generic/225
> @@ -38,8 +38,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs generic
> diff --git a/tests/generic/226 b/tests/generic/226
> index da45c9e..8b8f101 100755
> --- a/tests/generic/226
> +++ b/tests/generic/226
> @@ -32,7 +32,7 @@ status=1	# failure is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> +. ./common/rc
>  
>  _supported_fs generic
>  _supported_os Linux IRIX
> diff --git a/tests/generic/228 b/tests/generic/228
> index c8af133..ca375f4 100755
> --- a/tests/generic/228
> +++ b/tests/generic/228
> @@ -40,7 +40,7 @@ status=1	# failure is the default!
>  trap "_cleanup; exit \$status" 0 1 2 3 15 25
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> +. ./common/rc
>  
>  # real QA test starts here
>  # generic, but xfs_io's fallocate must work
> diff --git a/tests/generic/230 b/tests/generic/230
> index 51f6d85..f6883c0 100755
> --- a/tests/generic/230
> +++ b/tests/generic/230
> @@ -35,9 +35,9 @@ status=1	# failure is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.quota
> +. ./common/rc
> +. ./common/filter
> +. ./common/quota
>  
>  # real QA test starts here
>  _supported_fs generic
> diff --git a/tests/generic/231 b/tests/generic/231
> index 1a434d4..b50412c 100755
> --- a/tests/generic/231
> +++ b/tests/generic/231
> @@ -33,9 +33,9 @@ status=1	# failure is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.quota
> +. ./common/rc
> +. ./common/filter
> +. ./common/quota
>  
>  FSX_FILE_SIZE=64000000
>  FSX_ARGS="-q -l $FSX_FILE_SIZE -o 65536 -N 20000"
> diff --git a/tests/generic/232 b/tests/generic/232
> index 0f72733..ee0e16e 100755
> --- a/tests/generic/232
> +++ b/tests/generic/232
> @@ -33,9 +33,9 @@ status=1	# failure is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.quota
> +. ./common/rc
> +. ./common/filter
> +. ./common/quota
>  
>  _filter_num()
>  {
> diff --git a/tests/generic/233 b/tests/generic/233
> index 20ba711..1eb68c5 100755
> --- a/tests/generic/233
> +++ b/tests/generic/233
> @@ -34,9 +34,9 @@ status=1	# failure is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.quota
> +. ./common/rc
> +. ./common/filter
> +. ./common/quota
>  
>  FSX_FILE_SIZE=64000000
>  FSX_ARGS="-q -l $FSX_FILE_SIZE -o 65536 -S 191110531 -N 100000"
> diff --git a/tests/generic/234 b/tests/generic/234
> index e5c94e9..eb0871f 100755
> --- a/tests/generic/234
> +++ b/tests/generic/234
> @@ -35,9 +35,9 @@ status=1	# failure is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.quota
> +. ./common/rc
> +. ./common/filter
> +. ./common/quota
>  
>  test_setting()
>  {
> diff --git a/tests/generic/235 b/tests/generic/235
> index 85ed782..f430ba2 100755
> --- a/tests/generic/235
> +++ b/tests/generic/235
> @@ -35,9 +35,9 @@ status=1	# failure is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.quota
> +. ./common/rc
> +. ./common/filter
> +. ./common/quota
>  
>  # real QA test starts here
>  _supported_fs generic
> diff --git a/tests/generic/236 b/tests/generic/236
> index 016afae..10cf71a 100755
> --- a/tests/generic/236
> +++ b/tests/generic/236
> @@ -37,7 +37,7 @@ status=1	# failure is the default!
>  trap "_cleanup; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> +. ./common/rc
>  
>  # real QA test starts here
>  _supported_fs generic
> diff --git a/tests/generic/237 b/tests/generic/237
> index 7e54aed..e5c5a79 100755
> --- a/tests/generic/237
> +++ b/tests/generic/237
> @@ -34,9 +34,9 @@ status=1        # FAILure is the default!
>  trap "_cleanup; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.attr
> +. ./common/rc
> +. ./common/filter
> +. ./common/attr
>  
>  _cleanup()
>  {
> diff --git a/tests/generic/239 b/tests/generic/239
> index e25a6a0..bf39953 100755
> --- a/tests/generic/239
> +++ b/tests/generic/239
> @@ -38,8 +38,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  _supported_fs generic
>  _supported_os Linux
> diff --git a/tests/generic/240 b/tests/generic/240
> index 77fffe8..e692318 100755
> --- a/tests/generic/240
> +++ b/tests/generic/240
> @@ -44,8 +44,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  _supported_fs generic
>  _supported_os Linux
> diff --git a/tests/generic/241 b/tests/generic/241
> index b55344b..7c3f6e8 100755
> --- a/tests/generic/241
> +++ b/tests/generic/241
> @@ -37,8 +37,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  _supported_fs generic
>  _supported_os Linux
> diff --git a/tests/generic/245 b/tests/generic/245
> index 9832e92..2d888de 100755
> --- a/tests/generic/245
> +++ b/tests/generic/245
> @@ -33,8 +33,8 @@ tmp=/tmp/$$
>  status=1	# failure is the default!
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs generic
> diff --git a/tests/generic/246 b/tests/generic/246
> index 872e513..dd809fb 100755
> --- a/tests/generic/246
> +++ b/tests/generic/246
> @@ -34,8 +34,8 @@ tmp=/tmp/$$
>  status=1	# failure is the default!
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs generic
> diff --git a/tests/generic/247 b/tests/generic/247
> index 8a7e2c6..295259f 100755
> --- a/tests/generic/247
> +++ b/tests/generic/247
> @@ -38,8 +38,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  
> diff --git a/tests/generic/248 b/tests/generic/248
> index 7bb42a1..873313d 100755
> --- a/tests/generic/248
> +++ b/tests/generic/248
> @@ -38,8 +38,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  
> diff --git a/tests/generic/249 b/tests/generic/249
> index 288328c..6ba7ddb 100755
> --- a/tests/generic/249
> +++ b/tests/generic/249
> @@ -39,8 +39,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs generic
> diff --git a/tests/generic/251 b/tests/generic/251
> index 95633e1..7eeeedc 100755
> --- a/tests/generic/251
> +++ b/tests/generic/251
> @@ -37,8 +37,8 @@ chpid=0
>  mypid=$$
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs generic
> diff --git a/tests/generic/255 b/tests/generic/255
> index 3ef2449..2e8ddef 100755
> --- a/tests/generic/255
> +++ b/tests/generic/255
> @@ -38,9 +38,9 @@ _cleanup()
>  trap "_cleanup ; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.punch
> +. ./common/rc
> +. ./common/filter
> +. ./common/punch
>  
>  # real QA test starts here
>  _supported_fs generic 
> diff --git a/tests/generic/256 b/tests/generic/256
> index d60584b..ceeab0a 100755
> --- a/tests/generic/256
> +++ b/tests/generic/256
> @@ -38,9 +38,9 @@ _cleanup()
>  trap "_cleanup ; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.punch
> +. ./common/rc
> +. ./common/filter
> +. ./common/punch
>  
>  # real QA test starts here
>  _supported_fs generic
> diff --git a/tests/generic/257 b/tests/generic/257
> index 09a8fd8..a9ce73b 100755
> --- a/tests/generic/257
> +++ b/tests/generic/257
> @@ -36,8 +36,8 @@ _cleanup()
>  trap "_cleanup; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs generic
> diff --git a/tests/generic/258 b/tests/generic/258
> index ac03bb5..fb091ae 100755
> --- a/tests/generic/258
> +++ b/tests/generic/258
> @@ -40,7 +40,7 @@ _cleanup()
>  trap "_cleanup ; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> +. ./common/rc
>  
>  # real QA test starts here
>  _supported_fs generic
> diff --git a/tests/generic/260 b/tests/generic/260
> index d69e176..3c36996 100755
> --- a/tests/generic/260
> +++ b/tests/generic/260
> @@ -34,8 +34,8 @@ chpid=0
>  mypid=$$
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs generic
> diff --git a/tests/generic/263 b/tests/generic/263
> index 3e86efc..377b199 100755
> --- a/tests/generic/263
> +++ b/tests/generic/263
> @@ -32,8 +32,8 @@ status=1	# failure is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs generic
> diff --git a/tests/generic/269 b/tests/generic/269
> index 785d4de..6e33368 100755
> --- a/tests/generic/269
> +++ b/tests/generic/269
> @@ -32,8 +32,8 @@ status=1	# failure is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  # Disable all sync operations to get higher load
>  FSSTRESS_AVOID="$FSSTRESS_AVOID -ffsync=0 -fsync=0 -ffdatasync=0"
>  _workout()
> diff --git a/tests/generic/270 b/tests/generic/270
> index e6dbd8e..294bb62 100755
> --- a/tests/generic/270
> +++ b/tests/generic/270
> @@ -33,9 +33,9 @@ status=1	# failure is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.quota
> +. ./common/rc
> +. ./common/filter
> +. ./common/quota
>  
>  # Disable all sync operations to get higher load
>  FSSTRESS_AVOID="$FSSTRESS_AVOID -ffsync=0 -fsync=0 -ffdatasync=0"
> diff --git a/tests/generic/273 b/tests/generic/273
> index 3cfd3b0..d149808 100755
> --- a/tests/generic/273
> +++ b/tests/generic/273
> @@ -39,8 +39,8 @@ _cleanup()
>  	_scratch_unmount
>  }
>  
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  threads=50
>  count=2
> diff --git a/tests/generic/274 b/tests/generic/274
> index d5f09a4..5f3a51c 100755
> --- a/tests/generic/274
> +++ b/tests/generic/274
> @@ -41,8 +41,8 @@ _cleanup()
>  	_scratch_unmount
>  }
>  
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs generic
> diff --git a/tests/generic/275 b/tests/generic/275
> index 7782840..f83a644 100755
> --- a/tests/generic/275
> +++ b/tests/generic/275
> @@ -39,8 +39,8 @@ _cleanup()
>  	_scratch_unmount
>  }
>  
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs generic
> diff --git a/tests/generic/277 b/tests/generic/277
> index b85e429..8461ad9 100755
> --- a/tests/generic/277
> +++ b/tests/generic/277
> @@ -36,8 +36,8 @@ _cleanup()
>  trap "_cleanup ; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs generic
> diff --git a/tests/generic/280 b/tests/generic/280
> index 4b1e9b1..5491a6b 100755
> --- a/tests/generic/280
> +++ b/tests/generic/280
> @@ -38,9 +38,9 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.quota
> +. ./common/rc
> +. ./common/filter
> +. ./common/quota
>  
>  _require_scratch
>  _require_quota
> diff --git a/tests/generic/285 b/tests/generic/285
> index 93d793a..22b4a08 100644
> --- a/tests/generic/285
> +++ b/tests/generic/285
> @@ -34,8 +34,8 @@ status=1	# failure is the default!
>  trap "_cleanup; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  _supported_fs generic
>  _supported_os Linux
> diff --git a/tests/generic/286 b/tests/generic/286
> index 07ac029..a0d4df9 100644
> --- a/tests/generic/286
> +++ b/tests/generic/286
> @@ -31,8 +31,8 @@ status=1	# failure is the default!
>  trap "_cleanup; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs generic
> diff --git a/tests/generic/288 b/tests/generic/288
> index 175b9ef..7230358 100644
> --- a/tests/generic/288
> +++ b/tests/generic/288
> @@ -30,8 +30,8 @@ status=0
>  trap "exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs generic
> diff --git a/tests/generic/294 b/tests/generic/294
> index d4986d2..fa7f339 100644
> --- a/tests/generic/294
> +++ b/tests/generic/294
> @@ -38,8 +38,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  
> diff --git a/tests/generic/299 b/tests/generic/299
> index 532a301..5f3edc4 100644
> --- a/tests/generic/299
> +++ b/tests/generic/299
> @@ -34,8 +34,8 @@ status=1	# failure is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs generic
> diff --git a/tests/generic/300 b/tests/generic/300
> index a9fedbd..687e62d 100644
> --- a/tests/generic/300
> +++ b/tests/generic/300
> @@ -34,8 +34,8 @@ status=1	# failure is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs generic
> diff --git a/tests/shared/051 b/tests/shared/051
> index 0671f83..df90be9 100755
> --- a/tests/shared/051
> +++ b/tests/shared/051
> @@ -32,9 +32,9 @@ status=1	# FAILure is the default!
>  trap "_cleanup; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.attr
> +. ./common/rc
> +. ./common/filter
> +. ./common/attr
>  
>  _cleanup()
>  {
> diff --git a/tests/shared/218 b/tests/shared/218
> index 7c2bd53..c8b3f7d 100755
> --- a/tests/shared/218
> +++ b/tests/shared/218
> @@ -38,9 +38,9 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.defrag
> +. ./common/rc
> +. ./common/filter
> +. ./common/defrag
>  
>  # real QA test starts here
>  _supported_fs xfs ext4 btrfs
> diff --git a/tests/shared/243 b/tests/shared/243
> index 4884e29..05edc1e 100755
> --- a/tests/shared/243
> +++ b/tests/shared/243
> @@ -113,8 +113,8 @@ _check_ext4_eof_flag()
>  }
>  
>  # Get standard environment, filters and checks.
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # Prerequisites for the test run.
>  _supported_fs ext4 xfs btrfs gfs2
> diff --git a/tests/shared/272 b/tests/shared/272
> index 93a4967..0f812f3 100755
> --- a/tests/shared/272
> +++ b/tests/shared/272
> @@ -37,8 +37,8 @@ write_opt_list="iflag=noatime conv=notrunc conv=fsync"
>  [ $FSTYP = "ext4" ] && write_opt_list="$write_opt_list oflag=direct"
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  _workout()
>  {
>  	echo "Switch data journalling mode. Silence is golden."
> diff --git a/tests/shared/289 b/tests/shared/289
> index 091bceb..1879865 100755
> --- a/tests/shared/289
> +++ b/tests/shared/289
> @@ -37,8 +37,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  
> diff --git a/tests/shared/298 b/tests/shared/298
> index c5d1117..f1a3432 100644
> --- a/tests/shared/298
> +++ b/tests/shared/298
> @@ -28,8 +28,8 @@ echo "QA output created by $seq"
>  status=1	# failure is the default!
>  trap "_cleanup; exit \$status" 0 1 2 3 15
>  
> -. common.config
> -. common.rc
> +. common/config
> +. common/rc
>  
>  _supported_fs ext4 xfs
>  _supported_os Linux
> diff --git a/tests/shared/305 b/tests/shared/305
> index 49a06cc..bcb235f 100644
> --- a/tests/shared/305
> +++ b/tests/shared/305
> @@ -32,15 +32,15 @@ tmp=/tmp/$$
>  status=1	# failure is the default!
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  _supported_fs ext3 ext4 xfs btrfs reiserfs
>  _supported_os Linux
>  _need_to_be_root
>  _require_scratch
>  _require_fail_make_request
>  
> -# TODO: Function are common enough to be moved to common.blkdev
> +# TODO: Function are common enough to be moved to common/blkdev
>  SCRATCH_REAL_DEV=`readlink -f $SCRATCH_DEV`
>  SCRATCH_BDEV=`basename $SCRATCH_REAL_DEV`
>  
> diff --git a/tests/udf/098 b/tests/udf/098
> index 0cdcd16..9ae3614 100755
> --- a/tests/udf/098
> +++ b/tests/udf/098
> @@ -44,8 +44,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  _db_filter()
>  {
> diff --git a/tests/udf/101 b/tests/udf/101
> index 89507a9..0f5fe87 100755
> --- a/tests/udf/101
> +++ b/tests/udf/101
> @@ -38,8 +38,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs udf 
> diff --git a/tests/udf/102 b/tests/udf/102
> index bf3edd2..e27c086 100755
> --- a/tests/udf/102
> +++ b/tests/udf/102
> @@ -39,8 +39,8 @@ _cleanup()
>      _cleanup_testdir
>  }
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs udf 
> diff --git a/tests/xfs/003 b/tests/xfs/003
> index 56dd852..228dd17 100755
> --- a/tests/xfs/003
> +++ b/tests/xfs/003
> @@ -27,8 +27,8 @@ seqres=$RESULT_DIR/$seq
>  echo "QA output created by $seq"
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  tmp=/tmp/$$
>  here=`pwd`
> diff --git a/tests/xfs/004 b/tests/xfs/004
> index fb02b95..eb038b8 100755
> --- a/tests/xfs/004
> +++ b/tests/xfs/004
> @@ -54,8 +54,8 @@ _populate_scratch()
>  
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/008 b/tests/xfs/008
> index 1f66779..4bf6c00 100755
> --- a/tests/xfs/008
> +++ b/tests/xfs/008
> @@ -46,8 +46,8 @@ _filter()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  _do_test()
>  {
> diff --git a/tests/xfs/009 b/tests/xfs/009
> index 3e74160..f6031c4 100755
> --- a/tests/xfs/009
> +++ b/tests/xfs/009
> @@ -71,8 +71,8 @@ _filesize()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/012 b/tests/xfs/012
> index 4bd2afc..87c0b85 100755
> --- a/tests/xfs/012
> +++ b/tests/xfs/012
> @@ -45,8 +45,8 @@ _filesize()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  _do_test()
>  {
> diff --git a/tests/xfs/016 b/tests/xfs/016
> index fcb0637..2fc6af2 100755
> --- a/tests/xfs/016
> +++ b/tests/xfs/016
> @@ -171,8 +171,8 @@ _check_corrupt()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/017 b/tests/xfs/017
> index 98ae7e6..9fc16c2 100755
> --- a/tests/xfs/017
> +++ b/tests/xfs/017
> @@ -38,8 +38,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/018 b/tests/xfs/018
> index 7f22b54..60a1a64 100755
> --- a/tests/xfs/018
> +++ b/tests/xfs/018
> @@ -32,9 +32,9 @@ tmp=/tmp/$$
>  status=1	# failure is the default!
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.log
> +. ./common/rc
> +. ./common/filter
> +. ./common/log
>  
>  _cleanup()
>  {
> diff --git a/tests/xfs/019 b/tests/xfs/019
> index ff69423..d35d15b 100755
> --- a/tests/xfs/019
> +++ b/tests/xfs/019
> @@ -31,8 +31,8 @@ tmp=/tmp/$$
>  seqfull="$seqres.full"
>  status=1	# failure is the default!
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  _cleanup()
>  {
> diff --git a/tests/xfs/021 b/tests/xfs/021
> index 3cbf088..a727b51 100755
> --- a/tests/xfs/021
> +++ b/tests/xfs/021
> @@ -30,9 +30,9 @@ here=`pwd`
>  tmp=/tmp/$$
>  status=0	# success is the default!
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.attr
> +. ./common/rc
> +. ./common/filter
> +. ./common/attr
>  
>  _cleanup()
>  {
> diff --git a/tests/xfs/022 b/tests/xfs/022
> index 39f4b02..cd9b9ec 100755
> --- a/tests/xfs/022
> +++ b/tests/xfs/022
> @@ -35,8 +35,8 @@ tmp=/tmp/$$
>  status=0	# success is the default!
>  trap "rm -rf $tmp.*; exit \$status" 0 1 2 3 15
>  
> -. ./common.rc
> -. ./common.dump
> +. ./common/rc
> +. ./common/dump
>  
>  # link correct .out file
>  _link_out_file $seq.out $seqfull.out
> diff --git a/tests/xfs/023 b/tests/xfs/023
> index b133055..120be64 100755
> --- a/tests/xfs/023
> +++ b/tests/xfs/023
> @@ -34,8 +34,8 @@ status=0	# success is the default!
>  trap "rm -rf $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.dump
> +. ./common/rc
> +. ./common/dump
>  
>  # link correct .out file
>  _link_out_file $seq.out $seqfull.out
> diff --git a/tests/xfs/024 b/tests/xfs/024
> index ec5edc5..68e9788 100755
> --- a/tests/xfs/024
> +++ b/tests/xfs/024
> @@ -32,8 +32,8 @@ status=0	# success is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.dump
> +. ./common/rc
> +. ./common/dump
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/025 b/tests/xfs/025
> index 1e44732..ff29b99 100755
> --- a/tests/xfs/025
> +++ b/tests/xfs/025
> @@ -32,8 +32,8 @@ status=0	# success is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.dump
> +. ./common/rc
> +. ./common/dump
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/026 b/tests/xfs/026
> index 04bda76..4cd7789 100755
> --- a/tests/xfs/026
> +++ b/tests/xfs/026
> @@ -32,8 +32,8 @@ status=0	# success is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.dump
> +. ./common/rc
> +. ./common/dump
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/027 b/tests/xfs/027
> index 712378d..1005683 100755
> --- a/tests/xfs/027
> +++ b/tests/xfs/027
> @@ -32,8 +32,8 @@ status=0	# success is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.dump
> +. ./common/rc
> +. ./common/dump
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/028 b/tests/xfs/028
> index e70bc57..34c23e3 100755
> --- a/tests/xfs/028
> +++ b/tests/xfs/028
> @@ -32,8 +32,8 @@ status=0	# success is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.dump
> +. ./common/rc
> +. ./common/dump
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/029 b/tests/xfs/029
> index 4916c33..0709fce 100755
> --- a/tests/xfs/029
> +++ b/tests/xfs/029
> @@ -32,8 +32,8 @@ status=1	# failure is the default
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  _filter_logprint()
>  {
> diff --git a/tests/xfs/030 b/tests/xfs/030
> index b189128..c81925e 100755
> --- a/tests/xfs/030
> +++ b/tests/xfs/030
> @@ -41,9 +41,9 @@ _cleanup()
>  trap "_cleanup; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.repair
> +. ./common/rc
> +. ./common/filter
> +. ./common/repair
>  
>  # link correct .out file
>  _link_out_file $seq.out $seqfull.out
> diff --git a/tests/xfs/031 b/tests/xfs/031
> index 0f9a545..ef60367 100755
> --- a/tests/xfs/031
> +++ b/tests/xfs/031
> @@ -34,9 +34,9 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  rm -f $seqres.full
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.repair
> -. ./common.filter
> +. ./common/rc
> +. ./common/repair
> +. ./common/filter
>  
>  # link correct .out file
>  _link_out_file $seq.out $seqfull.out
> diff --git a/tests/xfs/032 b/tests/xfs/032
> index 343ff44..d255b66 100755
> --- a/tests/xfs/032
> +++ b/tests/xfs/032
> @@ -33,8 +33,8 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  rm -f $seqres.full
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/033 b/tests/xfs/033
> index e95cae4..bf906e0 100755
> --- a/tests/xfs/033
> +++ b/tests/xfs/033
> @@ -41,9 +41,9 @@ _cleanup()
>  trap "_cleanup; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.repair
> +. ./common/rc
> +. ./common/filter
> +. ./common/repair
>  
>  # link correct .out file
>  _link_out_file $seq.out $seqfull.out
> diff --git a/tests/xfs/034 b/tests/xfs/034
> index 372dead..6f73fdd 100755
> --- a/tests/xfs/034
> +++ b/tests/xfs/034
> @@ -40,8 +40,8 @@ _cleanup()
>  trap "_cleanup; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/035 b/tests/xfs/035
> index de9b9df..70eac93 100755
> --- a/tests/xfs/035
> +++ b/tests/xfs/035
> @@ -33,8 +33,8 @@ status=1	# failure is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.dump
> +. ./common/rc
> +. ./common/dump
>  
>  # link correct .out file
>  _link_out_file $seq.out $seqfull.out
> diff --git a/tests/xfs/036 b/tests/xfs/036
> index 1578e8e..32b8c87 100755
> --- a/tests/xfs/036
> +++ b/tests/xfs/036
> @@ -33,8 +33,8 @@ status=1	# failure is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.dump
> +. ./common/rc
> +. ./common/dump
>  
>  # link correct .out file
>  _link_out_file $seq.out $seqfull.out
> diff --git a/tests/xfs/037 b/tests/xfs/037
> index ca10429..ff736d5 100755
> --- a/tests/xfs/037
> +++ b/tests/xfs/037
> @@ -32,8 +32,8 @@ status=1	# failure is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.dump
> +. ./common/rc
> +. ./common/dump
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/038 b/tests/xfs/038
> index 64d2428..107e802 100755
> --- a/tests/xfs/038
> +++ b/tests/xfs/038
> @@ -32,8 +32,8 @@ status=1	# failure is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.dump
> +. ./common/rc
> +. ./common/dump
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/039 b/tests/xfs/039
> index ebab798..9747923 100755
> --- a/tests/xfs/039
> +++ b/tests/xfs/039
> @@ -33,8 +33,8 @@ status=1	# failure is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.dump
> +. ./common/rc
> +. ./common/dump
>  
>  # link correct .out file
>  _link_out_file $seq.out $seqfull.out
> diff --git a/tests/xfs/040 b/tests/xfs/040
> index 119a770..7c2a008 100755
> --- a/tests/xfs/040
> +++ b/tests/xfs/040
> @@ -32,8 +32,8 @@ status=1	# failure is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  [ -z "$KWORKAREA" ] && \
>  	_notrun "Can't run srcdiff without KWORKAREA set"
> diff --git a/tests/xfs/041 b/tests/xfs/041
> index dd50301..8b109fc 100755
> --- a/tests/xfs/041
> +++ b/tests/xfs/041
> @@ -41,8 +41,8 @@ _cleanup()
>  trap "_cleanup ; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/042 b/tests/xfs/042
> index 1127b46..db0fa28 100755
> --- a/tests/xfs/042
> +++ b/tests/xfs/042
> @@ -41,8 +41,8 @@ _cleanup()
>  trap "_cleanup ; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/043 b/tests/xfs/043
> index 9c56ac1..55a5225 100755
> --- a/tests/xfs/043
> +++ b/tests/xfs/043
> @@ -35,8 +35,8 @@ status=1	# failure is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.dump
> +. ./common/rc
> +. ./common/dump
>  
>  # link correct .out file
>  _link_out_file $seq.out $seqfull.out
> diff --git a/tests/xfs/044 b/tests/xfs/044
> index 3b330b9..2c20122 100755
> --- a/tests/xfs/044
> +++ b/tests/xfs/044
> @@ -36,8 +36,8 @@ status=1	# failure is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/045 b/tests/xfs/045
> index 9d07570..7a2ad45 100755
> --- a/tests/xfs/045
> +++ b/tests/xfs/045
> @@ -33,8 +33,8 @@ status=1	# failure is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  _get_existing_uuid()
>  {
> diff --git a/tests/xfs/046 b/tests/xfs/046
> index d5f4fca..841c12b 100755
> --- a/tests/xfs/046
> +++ b/tests/xfs/046
> @@ -32,8 +32,8 @@ status=1	# failure is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.dump
> +. ./common/rc
> +. ./common/dump
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/047 b/tests/xfs/047
> index 18960ea..d7c0dce 100755
> --- a/tests/xfs/047
> +++ b/tests/xfs/047
> @@ -32,8 +32,8 @@ status=1	# failure is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.dump
> +. ./common/rc
> +. ./common/dump
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/048 b/tests/xfs/048
> index a39ec66..40667e0 100755
> --- a/tests/xfs/048
> +++ b/tests/xfs/048
> @@ -32,8 +32,8 @@ status=1	# failure is the default!
>  trap "_cleanup; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  _cleanup()
>  {
> diff --git a/tests/xfs/049 b/tests/xfs/049
> index 6bbee3c..850d371 100755
> --- a/tests/xfs/049
> +++ b/tests/xfs/049
> @@ -46,8 +46,8 @@ status=1	# failure is the default!
>  trap "_cleanup ; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/050 b/tests/xfs/050
> index 669a624..774ed28 100755
> --- a/tests/xfs/050
> +++ b/tests/xfs/050
> @@ -32,9 +32,9 @@ tmp=/tmp/$$
>  status=1	# failure is the default!
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.quota
> +. ./common/rc
> +. ./common/filter
> +. ./common/quota
>  
>  _cleanup()
>  {
> diff --git a/tests/xfs/052 b/tests/xfs/052
> index 2abd78d..c2cf596 100755
> --- a/tests/xfs/052
> +++ b/tests/xfs/052
> @@ -34,9 +34,9 @@ tmp=/tmp/$$
>  status=1	# failure is the default!
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.quota
> +. ./common/rc
> +. ./common/filter
> +. ./common/quota
>  
>  _cleanup()
>  {
> diff --git a/tests/xfs/054 b/tests/xfs/054
> index 97590e8..8c18050 100755
> --- a/tests/xfs/054
> +++ b/tests/xfs/054
> @@ -32,9 +32,9 @@ tmp=/tmp/$$
>  status=1	# failure is the default!
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.quota
> +. ./common/rc
> +. ./common/filter
> +. ./common/quota
>  
>  _cleanup()
>  {
> diff --git a/tests/xfs/055 b/tests/xfs/055
> index 4c04b0a..cc747d3 100755
> --- a/tests/xfs/055
> +++ b/tests/xfs/055
> @@ -33,8 +33,8 @@ status=1	# failure is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.dump
> +. ./common/rc
> +. ./common/dump
>  
>  # link correct .out file
>  _link_out_file $seq.out $seqfull.out
> diff --git a/tests/xfs/056 b/tests/xfs/056
> index 8ab61f9..7e2624a 100755
> --- a/tests/xfs/056
> +++ b/tests/xfs/056
> @@ -33,8 +33,8 @@ status=0	# success is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.dump
> +. ./common/rc
> +. ./common/dump
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/057 b/tests/xfs/057
> index fd856d7..a525ef7 100755
> --- a/tests/xfs/057
> +++ b/tests/xfs/057
> @@ -32,8 +32,8 @@ status=1	# failure is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  _notrun "Place holder for IRIX test 057"
>  
> diff --git a/tests/xfs/058 b/tests/xfs/058
> index c800286..89c441a 100755
> --- a/tests/xfs/058
> +++ b/tests/xfs/058
> @@ -32,8 +32,8 @@ status=1	# failure is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  _notrun "Place holder for IRIX test 058"
>  
> diff --git a/tests/xfs/059 b/tests/xfs/059
> index c26fa4d..69338ac 100755
> --- a/tests/xfs/059
> +++ b/tests/xfs/059
> @@ -32,8 +32,8 @@ status=0	# success is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.dump
> +. ./common/rc
> +. ./common/dump
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/060 b/tests/xfs/060
> index 6adce78..477b964 100755
> --- a/tests/xfs/060
> +++ b/tests/xfs/060
> @@ -32,8 +32,8 @@ status=0	# success is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.dump
> +. ./common/rc
> +. ./common/dump
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/061 b/tests/xfs/061
> index e5a8413..2600f03 100755
> --- a/tests/xfs/061
> +++ b/tests/xfs/061
> @@ -32,8 +32,8 @@ status=0	# success is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.dump
> +. ./common/rc
> +. ./common/dump
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/063 b/tests/xfs/063
> index a2ee188..8494f8f 100755
> --- a/tests/xfs/063
> +++ b/tests/xfs/063
> @@ -32,10 +32,10 @@ status=1	# failure is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.dump
> -. ./common.attr
> +. ./common/rc
> +. ./common/filter
> +. ./common/dump
> +. ./common/attr
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/064 b/tests/xfs/064
> index 9ba542e..f06eda7 100755
> --- a/tests/xfs/064
> +++ b/tests/xfs/064
> @@ -32,9 +32,9 @@ status=1	# failure is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.dump
> +. ./common/rc
> +. ./common/filter
> +. ./common/dump
>  
>  
>  _ls_size_filter()
> diff --git a/tests/xfs/065 b/tests/xfs/065
> index ef1d10f..10e9b15 100755
> --- a/tests/xfs/065
> +++ b/tests/xfs/065
> @@ -35,9 +35,9 @@ status=1	# failure is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.dump
> +. ./common/rc
> +. ./common/filter
> +. ./common/dump
>  
>  #
>  # list recursively the directory
> diff --git a/tests/xfs/066 b/tests/xfs/066
> index 8709a2b..6d4e1c2 100755
> --- a/tests/xfs/066
> +++ b/tests/xfs/066
> @@ -32,9 +32,9 @@ status=1	# failure is the default!
>  trap "_cleanup; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.dump
> +. ./common/rc
> +. ./common/filter
> +. ./common/dump
>  
>  _cleanup()
>  {
> diff --git a/tests/xfs/067 b/tests/xfs/067
> index 87b3cc9..fbfaa1f 100755
> --- a/tests/xfs/067
> +++ b/tests/xfs/067
> @@ -32,9 +32,9 @@ status=1	# failure is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.attr
> +. ./common/rc
> +. ./common/filter
> +. ./common/attr
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/071 b/tests/xfs/071
> index cc0dd20..86c6899 100755
> --- a/tests/xfs/071
> +++ b/tests/xfs/071
> @@ -40,8 +40,8 @@ _cleanup()
>  trap "_cleanup; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  bitsperlong=`src/feature -w`
>  # link correct .out file
> diff --git a/tests/xfs/072 b/tests/xfs/072
> index d5bec3c..9949749 100755
> --- a/tests/xfs/072
> +++ b/tests/xfs/072
> @@ -39,8 +39,8 @@ status=1	# failure is the default!
>  trap "_cleanup; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/073 b/tests/xfs/073
> index 2ed2e97..1516639 100755
> --- a/tests/xfs/073
> +++ b/tests/xfs/073
> @@ -31,8 +31,8 @@ tmp=/tmp/$$
>  status=1	# failure is the default!
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # don't put fs images in /tmp
>  imgs=$TEST_DIR/$$
> diff --git a/tests/xfs/078 b/tests/xfs/078
> index df4fc6f..90a4a00 100755
> --- a/tests/xfs/078
> +++ b/tests/xfs/078
> @@ -42,8 +42,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # loop devices are available in Linux only
>  _supported_fs xfs
> diff --git a/tests/xfs/080 b/tests/xfs/080
> index fb5b6a6..b1cd0cb 100755
> --- a/tests/xfs/080
> +++ b/tests/xfs/080
> @@ -32,8 +32,8 @@ status=1	# failure is the default!
>  trap "_cleanup; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  _cleanup()
>  { 
> diff --git a/tests/xfs/081 b/tests/xfs/081
> index 44018bc..bdab460 100755
> --- a/tests/xfs/081
> +++ b/tests/xfs/081
> @@ -31,10 +31,10 @@ tmp=/tmp/$$
>  status=1	# failure is the default!
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.log
> -. ./common.quota
> +. ./common/rc
> +. ./common/filter
> +. ./common/log
> +. ./common/quota
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/082 b/tests/xfs/082
> index 9ab1611..fff1d6b 100755
> --- a/tests/xfs/082
> +++ b/tests/xfs/082
> @@ -32,9 +32,9 @@ tmp=/tmp/$$
>  status=1	# failure is the default!
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.log
> +. ./common/rc
> +. ./common/filter
> +. ./common/log
>  
>  _cleanup()
>  {
> diff --git a/tests/xfs/084 b/tests/xfs/084
> index 46aa837..0d17cf3 100755
> --- a/tests/xfs/084
> +++ b/tests/xfs/084
> @@ -33,8 +33,8 @@ status=1	# failure is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  _filter_resv()
>  {
> diff --git a/tests/xfs/085 b/tests/xfs/085
> index a02c42d..27f29a3 100755
> --- a/tests/xfs/085
> +++ b/tests/xfs/085
> @@ -35,9 +35,9 @@ status=1	# failure is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.log
> +. ./common/rc
> +. ./common/filter
> +. ./common/log
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/086 b/tests/xfs/086
> index 2e2d4cf..af09c7f 100755
> --- a/tests/xfs/086
> +++ b/tests/xfs/086
> @@ -34,9 +34,9 @@ status=1	# failure is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.log
> +. ./common/rc
> +. ./common/filter
> +. ./common/log
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/087 b/tests/xfs/087
> index 65812f6..3a3fb49 100755
> --- a/tests/xfs/087
> +++ b/tests/xfs/087
> @@ -34,10 +34,10 @@ status=1	# failure is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.log
> -. ./common.quota
> +. ./common/rc
> +. ./common/filter
> +. ./common/log
> +. ./common/quota
>  
>  _do_meta()
>  {
> diff --git a/tests/xfs/090 b/tests/xfs/090
> index 8477329..e8074d0 100755
> --- a/tests/xfs/090
> +++ b/tests/xfs/090
> @@ -32,8 +32,8 @@ status=1	# failure is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/092 b/tests/xfs/092
> index e65fe27..f195077 100755
> --- a/tests/xfs/092
> +++ b/tests/xfs/092
> @@ -38,8 +38,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  
> diff --git a/tests/xfs/094 b/tests/xfs/094
> index 6aa2d74..cb27559 100755
> --- a/tests/xfs/094
> +++ b/tests/xfs/094
> @@ -38,8 +38,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/095 b/tests/xfs/095
> index 9a74d5f..d137358 100755
> --- a/tests/xfs/095
> +++ b/tests/xfs/095
> @@ -38,9 +38,9 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.log
> +. ./common/rc
> +. ./common/filter
> +. ./common/log
>  
>  # real QA test starts here
>  
> diff --git a/tests/xfs/096 b/tests/xfs/096
> index 42673c5..d161019 100755
> --- a/tests/xfs/096
> +++ b/tests/xfs/096
> @@ -40,9 +40,9 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.log
> +. ./common/rc
> +. ./common/filter
> +. ./common/log
>  
>  #
>  # filter out counts which will vary
> diff --git a/tests/xfs/103 b/tests/xfs/103
> index 2d4fd48..ab54cbf 100755
> --- a/tests/xfs/103
> +++ b/tests/xfs/103
> @@ -32,8 +32,8 @@ status=1	# failure is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  _create_scratch()
>  {
> diff --git a/tests/xfs/104 b/tests/xfs/104
> index b0588e8..d31cf16 100755
> --- a/tests/xfs/104
> +++ b/tests/xfs/104
> @@ -32,8 +32,8 @@ status=1	# failure is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  _create_scratch()
>  {
> diff --git a/tests/xfs/106 b/tests/xfs/106
> index 651fe00..92c419d 100755
> --- a/tests/xfs/106
> +++ b/tests/xfs/106
> @@ -34,9 +34,9 @@ status=1	# failure is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.quota
> +. ./common/rc
> +. ./common/filter
> +. ./common/quota
>  
>  _supported_fs xfs
>  _supported_os Linux #IRIX
> diff --git a/tests/xfs/107 b/tests/xfs/107
> index e2300ce..3fefe51 100755
> --- a/tests/xfs/107
> +++ b/tests/xfs/107
> @@ -34,9 +34,9 @@ status=1	# failure is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.quota
> +. ./common/rc
> +. ./common/filter
> +. ./common/quota
>  
>  filter_xfs_quota()
>  {
> diff --git a/tests/xfs/108 b/tests/xfs/108
> index 809659d..5a47009 100755
> --- a/tests/xfs/108
> +++ b/tests/xfs/108
> @@ -32,9 +32,9 @@ status=1	# failure is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.quota
> +. ./common/rc
> +. ./common/filter
> +. ./common/quota
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/109 b/tests/xfs/109
> index 2e36d0f..5578c90 100755
> --- a/tests/xfs/109
> +++ b/tests/xfs/109
> @@ -32,8 +32,8 @@ status=1	# failure is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/110 b/tests/xfs/110
> index a2790c8..48bea45 100755
> --- a/tests/xfs/110
> +++ b/tests/xfs/110
> @@ -32,8 +32,8 @@ status=1	# failure is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/111 b/tests/xfs/111
> index af7cd65..bedead8 100755
> --- a/tests/xfs/111
> +++ b/tests/xfs/111
> @@ -32,8 +32,8 @@ status=1	# failure is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/114 b/tests/xfs/114
> index 954eaff..4dfdf86 100755
> --- a/tests/xfs/114
> +++ b/tests/xfs/114
> @@ -305,9 +305,9 @@ _test_dirstress()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.attr
> +. ./common/rc
> +. ./common/filter
> +. ./common/attr
>  
>  _supported_fs xfs
>  _supported_os IRIX
> diff --git a/tests/xfs/115 b/tests/xfs/115
> index aa281d6..0933c54 100755
> --- a/tests/xfs/115
> +++ b/tests/xfs/115
> @@ -92,9 +92,9 @@ _filter()
>  
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.attr
> +. ./common/rc
> +. ./common/filter
> +. ./common/attr
>  
>  _supported_fs xfs
>  _supported_os IRIX
> diff --git a/tests/xfs/116 b/tests/xfs/116
> index 4554d20..6aaae95 100755
> --- a/tests/xfs/116
> +++ b/tests/xfs/116
> @@ -40,9 +40,9 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.quota
> +. ./common/rc
> +. ./common/filter
> +. ./common/quota
>  
>  # real QA test starts here
>  
> diff --git a/tests/xfs/118 b/tests/xfs/118
> index e4ce711..abbb090 100755
> --- a/tests/xfs/118
> +++ b/tests/xfs/118
> @@ -40,9 +40,9 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.quota
> +. ./common/rc
> +. ./common/filter
> +. ./common/quota
>  
>  # real QA test starts here
>  
> diff --git a/tests/xfs/119 b/tests/xfs/119
> index 066ddbd..c7c46d9 100755
> --- a/tests/xfs/119
> +++ b/tests/xfs/119
> @@ -40,8 +40,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  
> diff --git a/tests/xfs/121 b/tests/xfs/121
> index f6dc83a..1e06e45 100755
> --- a/tests/xfs/121
> +++ b/tests/xfs/121
> @@ -36,9 +36,9 @@ status=1	# failure is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.log
> +. ./common/rc
> +. ./common/filter
> +. ./common/log
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/122 b/tests/xfs/122
> index 2a81728..8f1d5b4 100755
> --- a/tests/xfs/122
> +++ b/tests/xfs/122
> @@ -34,7 +34,7 @@ status=1	# failure is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment
> -. ./common.rc
> +. ./common/rc
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/134 b/tests/xfs/134
> index f38fc6e..298245f 100755
> --- a/tests/xfs/134
> +++ b/tests/xfs/134
> @@ -32,9 +32,9 @@ tmp=/tmp/$$
>  status=1	# failure is the default!
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.quota
> +. ./common/rc
> +. ./common/filter
> +. ./common/quota
>  
>  _cleanup()
>  {
> diff --git a/tests/xfs/136 b/tests/xfs/136
> index ec3f71a..9009c7b 100755
> --- a/tests/xfs/136
> +++ b/tests/xfs/136
> @@ -40,9 +40,9 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.attr
> +. ./common/rc
> +. ./common/filter
> +. ./common/attr
>  
>  # real QA test starts here
>  
> diff --git a/tests/xfs/137 b/tests/xfs/137
> index 5c0fc51..90dc1f5 100755
> --- a/tests/xfs/137
> +++ b/tests/xfs/137
> @@ -37,8 +37,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/138 b/tests/xfs/138
> index a0aeb82..d3c1009 100755
> --- a/tests/xfs/138
> +++ b/tests/xfs/138
> @@ -37,8 +37,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/139 b/tests/xfs/139
> index 9de1fca..1fbde58 100755
> --- a/tests/xfs/139
> +++ b/tests/xfs/139
> @@ -37,8 +37,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/140 b/tests/xfs/140
> index 8564b28..ce52272 100755
> --- a/tests/xfs/140
> +++ b/tests/xfs/140
> @@ -37,8 +37,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/142 b/tests/xfs/142
> index e09ae3f..5a2ef9e 100755
> --- a/tests/xfs/142
> +++ b/tests/xfs/142
> @@ -37,9 +37,9 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.dmapi
> +. ./common/rc
> +. ./common/filter
> +. ./common/dmapi
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/143 b/tests/xfs/143
> index 686be64..c86cc0a 100755
> --- a/tests/xfs/143
> +++ b/tests/xfs/143
> @@ -37,9 +37,9 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.dmapi
> +. ./common/rc
> +. ./common/filter
> +. ./common/dmapi
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/144 b/tests/xfs/144
> index cf5eca7..0b5b21d 100755
> --- a/tests/xfs/144
> +++ b/tests/xfs/144
> @@ -37,9 +37,9 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.dmapi
> +. ./common/rc
> +. ./common/filter
> +. ./common/dmapi
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/145 b/tests/xfs/145
> index 2a4b2f6..c8444f0 100755
> --- a/tests/xfs/145
> +++ b/tests/xfs/145
> @@ -37,9 +37,9 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.dmapi
> +. ./common/rc
> +. ./common/filter
> +. ./common/dmapi
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/146 b/tests/xfs/146
> index e79d59e..1e13d95 100755
> --- a/tests/xfs/146
> +++ b/tests/xfs/146
> @@ -44,9 +44,9 @@ _report_filter () {
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.dmapi
> +. ./common/rc
> +. ./common/filter
> +. ./common/dmapi
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/147 b/tests/xfs/147
> index c65dde9..c22f24a 100755
> --- a/tests/xfs/147
> +++ b/tests/xfs/147
> @@ -37,9 +37,9 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.dmapi
> +. ./common/rc
> +. ./common/filter
> +. ./common/dmapi
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/148 b/tests/xfs/148
> index 49892ab..c60d219 100755
> --- a/tests/xfs/148
> +++ b/tests/xfs/148
> @@ -41,9 +41,9 @@ _cleanup()
>  trap "_cleanup; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.repair
> +. ./common/rc
> +. ./common/filter
> +. ./common/repair
>  
>  [ -z "$XFS_PARALLEL_REPAIR64_PROG" ] && _notrun "parallel repair binary xfs_prepair64 is not installed"
>  
> diff --git a/tests/xfs/149 b/tests/xfs/149
> index 780e3ae..fe6b70e 100755
> --- a/tests/xfs/149
> +++ b/tests/xfs/149
> @@ -34,9 +34,9 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  rm -f $seqres.full
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.repair
> -. ./common.filter
> +. ./common/rc
> +. ./common/repair
> +. ./common/filter
>  
>  [ -z "$XFS_PARALLEL_REPAIR_PROG" ] && _notrun "parallel repair binary xfs_prepair is not installed"
>  
> diff --git a/tests/xfs/150 b/tests/xfs/150
> index 529b6b4..3bf1c8b 100755
> --- a/tests/xfs/150
> +++ b/tests/xfs/150
> @@ -42,9 +42,9 @@ _filter_fs_handle()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.dmapi
> +. ./common/rc
> +. ./common/filter
> +. ./common/dmapi
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/151 b/tests/xfs/151
> index 9de8ab4..d2e21f3 100755
> --- a/tests/xfs/151
> +++ b/tests/xfs/151
> @@ -63,9 +63,9 @@ _check_sids()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.dmapi
> +. ./common/rc
> +. ./common/filter
> +. ./common/dmapi
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/152 b/tests/xfs/152
> index 4b9d471..310f0dc 100755
> --- a/tests/xfs/152
> +++ b/tests/xfs/152
> @@ -43,9 +43,9 @@ _filter_handles()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.dmapi
> +. ./common/rc
> +. ./common/filter
> +. ./common/dmapi
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/153 b/tests/xfs/153
> index 86df036..7b9a316 100755
> --- a/tests/xfs/153
> +++ b/tests/xfs/153
> @@ -38,9 +38,9 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.dmapi
> +. ./common/rc
> +. ./common/filter
> +. ./common/dmapi
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/154 b/tests/xfs/154
> index 528ec9c..c281b37 100755
> --- a/tests/xfs/154
> +++ b/tests/xfs/154
> @@ -37,9 +37,9 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.dmapi
> +. ./common/rc
> +. ./common/filter
> +. ./common/dmapi
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/155 b/tests/xfs/155
> index 1c4ea6c..23316f2 100755
> --- a/tests/xfs/155
> +++ b/tests/xfs/155
> @@ -37,9 +37,9 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.dmapi
> +. ./common/rc
> +. ./common/filter
> +. ./common/dmapi
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/156 b/tests/xfs/156
> index 0a73b6b..88b8cbf 100755
> --- a/tests/xfs/156
> +++ b/tests/xfs/156
> @@ -37,9 +37,9 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.dmapi
> +. ./common/rc
> +. ./common/filter
> +. ./common/dmapi
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/157 b/tests/xfs/157
> index 91819ef..a1243dc 100755
> --- a/tests/xfs/157
> +++ b/tests/xfs/157
> @@ -37,9 +37,9 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.dmapi
> +. ./common/rc
> +. ./common/filter
> +. ./common/dmapi
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/158 b/tests/xfs/158
> index ef8d4d1..5c4dfcd 100755
> --- a/tests/xfs/158
> +++ b/tests/xfs/158
> @@ -37,9 +37,9 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.dmapi
> +. ./common/rc
> +. ./common/filter
> +. ./common/dmapi
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/159 b/tests/xfs/159
> index 8f80482..8d15162 100755
> --- a/tests/xfs/159
> +++ b/tests/xfs/159
> @@ -37,9 +37,9 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.dmapi
> +. ./common/rc
> +. ./common/filter
> +. ./common/dmapi
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/160 b/tests/xfs/160
> index 2323697..44e9f2f 100755
> --- a/tests/xfs/160
> +++ b/tests/xfs/160
> @@ -37,9 +37,9 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.dmapi
> +. ./common/rc
> +. ./common/filter
> +. ./common/dmapi
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/161 b/tests/xfs/161
> index 45210c7..74d6dbe 100755
> --- a/tests/xfs/161
> +++ b/tests/xfs/161
> @@ -44,9 +44,9 @@ _filter_get_allocinfo()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.dmapi
> +. ./common/rc
> +. ./common/filter
> +. ./common/dmapi
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/162 b/tests/xfs/162
> index 67aec9a..64d001c 100755
> --- a/tests/xfs/162
> +++ b/tests/xfs/162
> @@ -37,9 +37,9 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.dmapi
> +. ./common/rc
> +. ./common/filter
> +. ./common/dmapi
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/163 b/tests/xfs/163
> index 434f100..a8cb06a 100755
> --- a/tests/xfs/163
> +++ b/tests/xfs/163
> @@ -48,9 +48,9 @@ _filter_handles()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.dmapi
> +. ./common/rc
> +. ./common/filter
> +. ./common/dmapi
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/164 b/tests/xfs/164
> index 8af0b0d..cfd77fa 100755
> --- a/tests/xfs/164
> +++ b/tests/xfs/164
> @@ -61,8 +61,8 @@ _filter_bmap()
>  
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  
> diff --git a/tests/xfs/165 b/tests/xfs/165
> index 72376f3..7806a33 100755
> --- a/tests/xfs/165
> +++ b/tests/xfs/165
> @@ -57,8 +57,8 @@ _filter_bmap()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  
> diff --git a/tests/xfs/166 b/tests/xfs/166
> index 3170fa6..02b3237 100755
> --- a/tests/xfs/166
> +++ b/tests/xfs/166
> @@ -38,8 +38,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # assumes 1st, 3rd and 5th blocks are single written blocks,
>  # the others are unwritten.
> diff --git a/tests/xfs/167 b/tests/xfs/167
> index 6800d24..d75de23 100755
> --- a/tests/xfs/167
> +++ b/tests/xfs/167
> @@ -50,8 +50,8 @@ workout()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/168 b/tests/xfs/168
> index 67f1e19..4ca2869 100755
> --- a/tests/xfs/168
> +++ b/tests/xfs/168
> @@ -62,9 +62,9 @@ s/^\s*\n//g ;
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.dmapi
> +. ./common/rc
> +. ./common/filter
> +. ./common/dmapi
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/170 b/tests/xfs/170
> index f470946..f772bc4 100755
> --- a/tests/xfs/170
> +++ b/tests/xfs/170
> @@ -41,9 +41,9 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.filestreams
> +. ./common/rc
> +. ./common/filter
> +. ./common/filestreams
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/171 b/tests/xfs/171
> index af7a216..a6151f0 100755
> --- a/tests/xfs/171
> +++ b/tests/xfs/171
> @@ -40,9 +40,9 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.filestreams
> +. ./common/rc
> +. ./common/filter
> +. ./common/filestreams
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/172 b/tests/xfs/172
> index 50eda81..43ef5ab 100755
> --- a/tests/xfs/172
> +++ b/tests/xfs/172
> @@ -40,9 +40,9 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.filestreams
> +. ./common/rc
> +. ./common/filter
> +. ./common/filestreams
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/173 b/tests/xfs/173
> index 6761a8a..8c4f9a6 100755
> --- a/tests/xfs/173
> +++ b/tests/xfs/173
> @@ -40,9 +40,9 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.filestreams
> +. ./common/rc
> +. ./common/filter
> +. ./common/filestreams
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/174 b/tests/xfs/174
> index ffb6754..5e2e61b 100755
> --- a/tests/xfs/174
> +++ b/tests/xfs/174
> @@ -40,9 +40,9 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.filestreams
> +. ./common/rc
> +. ./common/filter
> +. ./common/filestreams
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/175 b/tests/xfs/175
> index 4753f21..16fcfcc 100755
> --- a/tests/xfs/175
> +++ b/tests/xfs/175
> @@ -41,10 +41,10 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.dmapi
> -. ./common.punch
> +. ./common/rc
> +. ./common/filter
> +. ./common/dmapi
> +. ./common/punch
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/176 b/tests/xfs/176
> index 3fe9f04..ea07e00 100755
> --- a/tests/xfs/176
> +++ b/tests/xfs/176
> @@ -38,10 +38,10 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.dmapi
> -. ./common.punch
> +. ./common/rc
> +. ./common/filter
> +. ./common/dmapi
> +. ./common/punch
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/177 b/tests/xfs/177
> index 49ca282..2558201 100755
> --- a/tests/xfs/177
> +++ b/tests/xfs/177
> @@ -39,9 +39,9 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.dmapi
> +. ./common/rc
> +. ./common/filter
> +. ./common/dmapi
>  
>  # real QA test starts here
>  
> diff --git a/tests/xfs/178 b/tests/xfs/178
> index 084aeb9..9db8d05 100755
> --- a/tests/xfs/178
> +++ b/tests/xfs/178
> @@ -53,9 +53,9 @@ _dd_repair_check()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.repair
> +. ./common/rc
> +. ./common/filter
> +. ./common/repair
>  
>  # real QA test starts here
>  
> diff --git a/tests/xfs/179 b/tests/xfs/179
> index 451d7cc..6402eda 100755
> --- a/tests/xfs/179
> +++ b/tests/xfs/179
> @@ -38,8 +38,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/180 b/tests/xfs/180
> index 15e0221..404f352 100755
> --- a/tests/xfs/180
> +++ b/tests/xfs/180
> @@ -38,8 +38,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/181 b/tests/xfs/181
> index 35e808f..38d556c 100755
> --- a/tests/xfs/181
> +++ b/tests/xfs/181
> @@ -43,9 +43,9 @@ status=1	# failure is the default!
>  trap "_cleanup; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.log
> +. ./common/rc
> +. ./common/filter
> +. ./common/log
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/182 b/tests/xfs/182
> index 7495eb1..f55e018 100755
> --- a/tests/xfs/182
> +++ b/tests/xfs/182
> @@ -38,8 +38,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/183 b/tests/xfs/183
> index 5a7587f..764c1d5 100755
> --- a/tests/xfs/183
> +++ b/tests/xfs/183
> @@ -39,8 +39,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  
> diff --git a/tests/xfs/185 b/tests/xfs/185
> index f00858b..7905801 100755
> --- a/tests/xfs/185
> +++ b/tests/xfs/185
> @@ -37,9 +37,9 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.dmapi
> +. ./common/rc
> +. ./common/filter
> +. ./common/dmapi
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/186 b/tests/xfs/186
> index 46cd087..44edaf7 100755
> --- a/tests/xfs/186
> +++ b/tests/xfs/186
> @@ -136,9 +136,9 @@ _changeto_attr1()
>  
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.attr
> +. ./common/rc
> +. ./common/filter
> +. ./common/attr
>  
>  # real QA test starts here
>  
> diff --git a/tests/xfs/187 b/tests/xfs/187
> index c414017..9cf1305 100755
> --- a/tests/xfs/187
> +++ b/tests/xfs/187
> @@ -48,9 +48,9 @@ _filter_version()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.attr
> +. ./common/rc
> +. ./common/filter
> +. ./common/attr
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/188 b/tests/xfs/188
> index a8fe431..6332085 100755
> --- a/tests/xfs/188
> +++ b/tests/xfs/188
> @@ -46,8 +46,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/189 b/tests/xfs/189
> index 24cc29e..af6a16a 100755
> --- a/tests/xfs/189
> +++ b/tests/xfs/189
> @@ -192,8 +192,8 @@ _putback_scratch_fstab()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/190 b/tests/xfs/190
> index c760ee6..614a80c 100755
> --- a/tests/xfs/190
> +++ b/tests/xfs/190
> @@ -44,8 +44,8 @@ status=0    # success is the default!
>  rm -f $seqres.full
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/191 b/tests/xfs/191
> index d3b227c..e9aef20 100755
> --- a/tests/xfs/191
> +++ b/tests/xfs/191
> @@ -32,8 +32,8 @@ status=1	# failure is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  
> diff --git a/tests/xfs/194 b/tests/xfs/194
> index 4609a17..f56702a 100755
> --- a/tests/xfs/194
> +++ b/tests/xfs/194
> @@ -37,8 +37,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # only xfs supported due to use of xfs_bmap
>  _supported_fs xfs
> diff --git a/tests/xfs/195 b/tests/xfs/195
> index e0755f4..d67ce9f 100755
> --- a/tests/xfs/195
> +++ b/tests/xfs/195
> @@ -56,8 +56,8 @@ _do_dump()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/196 b/tests/xfs/196
> index 20b20b2..189f4ce 100755
> --- a/tests/xfs/196
> +++ b/tests/xfs/196
> @@ -41,9 +41,9 @@ _cleanup()
>  trap "_cleanup; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.quota
> +. ./common/rc
> +. ./common/filter
> +. ./common/quota
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/197 b/tests/xfs/197
> index b17ea37..bc2de9d 100755
> --- a/tests/xfs/197
> +++ b/tests/xfs/197
> @@ -42,8 +42,8 @@ _cleanup()
>  trap "_cleanup; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/199 b/tests/xfs/199
> index fbca7c6..1d64e02 100755
> --- a/tests/xfs/199
> +++ b/tests/xfs/199
> @@ -40,8 +40,8 @@ _cleanup()
>  trap "_cleanup; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/200 b/tests/xfs/200
> index a70fcfe..5d4d94c 100755
> --- a/tests/xfs/200
> +++ b/tests/xfs/200
> @@ -37,8 +37,8 @@ _cleanup()
>  trap "_cleanup; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/201 b/tests/xfs/201
> index 3f5b1fb..fa7bcf6 100755
> --- a/tests/xfs/201
> +++ b/tests/xfs/201
> @@ -50,8 +50,8 @@ _cleanup()
>  trap "_cleanup; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/202 b/tests/xfs/202
> index b0591d3..15c6603 100755
> --- a/tests/xfs/202
> +++ b/tests/xfs/202
> @@ -30,9 +30,9 @@ tmp=/tmp/$$
>  status=1	# failure is the default!
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.repair
> +. ./common/rc
> +. ./common/filter
> +. ./common/repair
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/203 b/tests/xfs/203
> index 98ee792..7e18ca3 100755
> --- a/tests/xfs/203
> +++ b/tests/xfs/203
> @@ -65,8 +65,8 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
>  rm -f $seqres.full
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/205 b/tests/xfs/205
> index 8b973c2..c9b73a1 100755
> --- a/tests/xfs/205
> +++ b/tests/xfs/205
> @@ -30,8 +30,8 @@ tmp=/tmp/$$
>  status=1	# failure is the default!
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/206 b/tests/xfs/206
> index 909a908..fcbdd9e 100755
> --- a/tests/xfs/206
> +++ b/tests/xfs/206
> @@ -45,8 +45,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  
> diff --git a/tests/xfs/216 b/tests/xfs/216
> index 486bd9d..a21df9d 100755
> --- a/tests/xfs/216
> +++ b/tests/xfs/216
> @@ -38,8 +38,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/217 b/tests/xfs/217
> index 25d3a15..25a6c01 100755
> --- a/tests/xfs/217
> +++ b/tests/xfs/217
> @@ -38,8 +38,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/220 b/tests/xfs/220
> index a696aa0..181a10a 100755
> --- a/tests/xfs/220
> +++ b/tests/xfs/220
> @@ -41,9 +41,9 @@ _cleanup()
>  trap "_cleanup; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.quota
> +. ./common/rc
> +. ./common/filter
> +. ./common/quota
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/222 b/tests/xfs/222
> index 556baff..0e5aaf6 100755
> --- a/tests/xfs/222
> +++ b/tests/xfs/222
> @@ -41,8 +41,8 @@ _cleanup()
>  trap "_cleanup ; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/227 b/tests/xfs/227
> index 650c72e..3816e9f 100755
> --- a/tests/xfs/227
> +++ b/tests/xfs/227
> @@ -43,8 +43,8 @@ _cleanup()
>  trap "_cleanup ; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/229 b/tests/xfs/229
> index eef6a2d..3e02421 100755
> --- a/tests/xfs/229
> +++ b/tests/xfs/229
> @@ -44,7 +44,7 @@ _cleanup()
>  trap "_cleanup ; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> +. ./common/rc
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/238 b/tests/xfs/238
> index 00dd620..0bbda8f 100755
> --- a/tests/xfs/238
> +++ b/tests/xfs/238
> @@ -37,8 +37,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  
> diff --git a/tests/xfs/242 b/tests/xfs/242
> index 6476d5a..80b0b1d 100755
> --- a/tests/xfs/242
> +++ b/tests/xfs/242
> @@ -38,9 +38,9 @@ _cleanup()
>  trap "_cleanup ; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.punch
> +. ./common/rc
> +. ./common/filter
> +. ./common/punch
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/244 b/tests/xfs/244
> index 566caaa..d899a3d 100755
> --- a/tests/xfs/244
> +++ b/tests/xfs/244
> @@ -32,9 +32,9 @@ status=1	# failure is the default!
>  trap "_cleanup; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.quota
> +. ./common/rc
> +. ./common/filter
> +. ./common/quota
>  
>  _cleanup()
>  {
> diff --git a/tests/xfs/250 b/tests/xfs/250
> index a6edc2d..b9953f7 100755
> --- a/tests/xfs/250
> +++ b/tests/xfs/250
> @@ -40,8 +40,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/252 b/tests/xfs/252
> index be3bfcf..7015f87 100755
> --- a/tests/xfs/252
> +++ b/tests/xfs/252
> @@ -38,9 +38,9 @@ _cleanup()
>  trap "_cleanup ; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.punch
> +. ./common/rc
> +. ./common/filter
> +. ./common/punch
>  
>  # real QA test starts here
>  _supported_fs xfs 
> diff --git a/tests/xfs/253 b/tests/xfs/253
> index 7c221a5..98c61d6 100755
> --- a/tests/xfs/253
> +++ b/tests/xfs/253
> @@ -50,8 +50,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  _require_scratch
>  
> diff --git a/tests/xfs/259 b/tests/xfs/259
> index 6a29230..59eeaca 100755
> --- a/tests/xfs/259
> +++ b/tests/xfs/259
> @@ -36,7 +36,7 @@ _cleanup()
>  trap "_cleanup ; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> +. ./common/rc
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/261 b/tests/xfs/261
> index 7c575aa..950c539 100755
> --- a/tests/xfs/261
> +++ b/tests/xfs/261
> @@ -46,9 +46,9 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.quota
> +. ./common/rc
> +. ./common/filter
> +. ./common/quota
>  
>  echo "Silence is golden."
>  
> diff --git a/tests/xfs/262 b/tests/xfs/262
> index 2ed7123..01f7f8b 100755
> --- a/tests/xfs/262
> +++ b/tests/xfs/262
> @@ -52,9 +52,9 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.quota
> +. ./common/rc
> +. ./common/filter
> +. ./common/quota
>  
>  echo "Silence is golden."
>  
> diff --git a/tests/xfs/266 b/tests/xfs/266
> index 3efbb75..70d4b7f 100755
> --- a/tests/xfs/266
> +++ b/tests/xfs/266
> @@ -42,8 +42,8 @@ _add_and_append_dumpdir_fill()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.dump
> +. ./common/rc
> +. ./common/dump
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/267 b/tests/xfs/267
> index 05360a9..65e5321 100755
> --- a/tests/xfs/267
> +++ b/tests/xfs/267
> @@ -51,9 +51,9 @@ End-of-File
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.dump
> -. ./common.attr
> +. ./common/rc
> +. ./common/dump
> +. ./common/attr
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/268 b/tests/xfs/268
> index c0c45f2..bc2bb62 100755
> --- a/tests/xfs/268
> +++ b/tests/xfs/268
> @@ -54,9 +54,9 @@ End-of-File
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.dump
> -. ./common.attr
> +. ./common/rc
> +. ./common/dump
> +. ./common/attr
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/278 b/tests/xfs/278
> index 6439eb4..6aa0e4d 100755
> --- a/tests/xfs/278
> +++ b/tests/xfs/278
> @@ -40,8 +40,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/279 b/tests/xfs/279
> index e96c823..872f8be 100755
> --- a/tests/xfs/279
> +++ b/tests/xfs/279
> @@ -39,9 +39,9 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.scsi_debug
> +. ./common/rc
> +. ./common/filter
> +. ./common/scsi_debug
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/281 b/tests/xfs/281
> index 7aae2a5..fbfa06e 100755
> --- a/tests/xfs/281
> +++ b/tests/xfs/281
> @@ -32,8 +32,8 @@ status=1	# failure is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.dump
> +. ./common/rc
> +. ./common/dump
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/282 b/tests/xfs/282
> index 0680b9c..8ddb258 100755
> --- a/tests/xfs/282
> +++ b/tests/xfs/282
> @@ -34,8 +34,8 @@ status=1	# failure is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.dump
> +. ./common/rc
> +. ./common/dump
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/283 b/tests/xfs/283
> index 75ee26e..cd9609e 100755
> --- a/tests/xfs/283
> +++ b/tests/xfs/283
> @@ -34,8 +34,8 @@ status=1	# failure is the default!
>  trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.dump
> +. ./common/rc
> +. ./common/dump
>  
>  # real QA test starts here
>  _supported_fs xfs
> diff --git a/tests/xfs/287 b/tests/xfs/287
> index 7e68045..10853d1 100644
> --- a/tests/xfs/287
> +++ b/tests/xfs/287
> @@ -33,8 +33,8 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
>  rm -f $seqres.full
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.quota
> +. ./common/rc
> +. ./common/quota
>  
>  _cleanup()
>  {
> diff --git a/tests/xfs/290 b/tests/xfs/290
> index 7198b72..547a0ba 100644
> --- a/tests/xfs/290
> +++ b/tests/xfs/290
> @@ -36,8 +36,8 @@ status=1	# failure is the default!
>  trap "exit \$status" 0 1 2 3 15
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  
> diff --git a/tests/xfs/291 b/tests/xfs/291
> index 4871eaa..f842679 100644
> --- a/tests/xfs/291
> +++ b/tests/xfs/291
> @@ -37,8 +37,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  _supported_fs xfs
>  _supported_os IRIX Linux
> diff --git a/tests/xfs/292 b/tests/xfs/292
> index b617c9d..d67db47 100644
> --- a/tests/xfs/292
> +++ b/tests/xfs/292
> @@ -38,8 +38,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  
> diff --git a/tests/xfs/293 b/tests/xfs/293
> index 5aa350b..d1a2853 100644
> --- a/tests/xfs/293
> +++ b/tests/xfs/293
> @@ -37,8 +37,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  
> diff --git a/tests/xfs/295 b/tests/xfs/295
> index bb2fe73..79f27bd 100644
> --- a/tests/xfs/295
> +++ b/tests/xfs/295
> @@ -37,8 +37,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  
> diff --git a/tests/xfs/296 b/tests/xfs/296
> index 24ee1c8..610c2ec 100644
> --- a/tests/xfs/296
> +++ b/tests/xfs/296
> @@ -37,9 +37,9 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> -. ./common.dump
> +. ./common/rc
> +. ./common/filter
> +. ./common/dump
>  
>  # real QA test starts here
>  
> diff --git a/tests/xfs/297 b/tests/xfs/297
> index 6240ca7..3fe32f1 100644
> --- a/tests/xfs/297
> +++ b/tests/xfs/297
> @@ -39,8 +39,8 @@ _cleanup()
>  }
>  
>  # get standard environment, filters and checks
> -. ./common.rc
> -. ./common.filter
> +. ./common/rc
> +. ./common/filter
>  
>  # real QA test starts here
>  _supported_fs xfs
> -- 
> 1.7.10.4
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
