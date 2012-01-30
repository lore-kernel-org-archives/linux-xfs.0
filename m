Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0UKYt3w120201 for <xfs@oss.sgi.com>; Mon, 30 Jan 2012 14:34:55 -0600
Received: from mail-lpp01m010-f53.google.com (mail-lpp01m010-f53.google.com
	[209.85.215.53]) by cuda.sgi.com with ESMTP id cw9ILB2JBIFXcEZZ
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 30 Jan 2012 12:34:53 -0800 (PST)
Received: by lahd3 with SMTP id d3so2911975lah.26
	for <xfs@oss.sgi.com>; Mon, 30 Jan 2012 12:34:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAAA8XhMJeoUSMmcCizHqoFLrymbs7Hz216+7d445u6tV+ZC=fg@mail.gmail.com>
References: <CAAA8XhOXuszcyCaMOcVWb-erGAJQdhBHCX-gsJ4KpH+Td7+bPQ@mail.gmail.com>
	<20120124213936.GA1505@infradead.org>
	<CAAA8XhMf9BhZP5csLfGVVbQxN7Uqh-+R6aqCLfezdiTECaRRjg@mail.gmail.com>
	<20120127105859.GC23335@infradead.org>
	<CAAA8XhOoF_AN_-1PsYQ+hp7adc08YuYqvA_3Bv9nqtuOzO1kOg@mail.gmail.com>
	<20120127191532.GA25529@infradead.org>
	<CAAA8XhMJeoUSMmcCizHqoFLrymbs7Hz216+7d445u6tV+ZC=fg@mail.gmail.com>
Date: Mon, 30 Jan 2012 18:34:52 -0200
Message-ID: <CAAA8XhPTnj+d1CzmpDvrYLRuZ3=p6A0sN1z-=yswezxA+MkF+A@mail.gmail.com>
Subject: Re: XFS problem
From: Kelbel Junior <jymmyjr@gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Hi again, Christoph.

How you prefer to pre allocate space?
xfs I/O or by 'dd' to do it?

What other information you would like to better understand and manage
to solve this problem?

Below sending the first lines of the output 'filefrag -v cachefile' to
check if there is some useful information ... if you want, I can make
available for download a file with the output of the 'filefrag-v'

####
Filesystem type is: 58465342
File size of cachefile is 885075181568 (216082808 blocks, blocksize 4096)
 ext  logical physical expected length flags
   0        0    37651               1
   1        8  8356011    37651      2
   2       10 42985973  8356012      5
   3       16  8356008 42985977      1
   4       24 14384348  8356008      3
   5       27 42978781 14384350      4
   6       31 49416416 42978784      1
   7       32 14384398 49416416      3
   8       35 42985981 14384400      3
   9       40 14384407 42985983      2
  10       42 42990181 14384408      4
  11       48 14384433 42990184      3
  12       56 14384445 14384435      2
  13       64 14384470 14384446      2
  14       66 43029387 14384471      2
  15       72 14384492 43029388      2
  16       80 14384556 14384493      2
  17       82 43108186 14384557      2
  18       88 14388688 43108187      3
  19       96 14391631 14388690      3
  20      104 14391634               1
  21      112 14391635               1
  22      113 41118314 14391635      1
  23      120 14391625 41118314      1
  24      121 43107765 14391625      5
  25      128 14391888 43107769      7
  26      136 14391793 14391894      6
  27      142 14391806 14391798      1
  28      144 14391802 14391806      4
  29      152 14391810 14391805      4
  30      160 14391818 14391813      3
  31      168 14391826 14391820      4
  32      176 14391830               1
  33      184 30960375 14391830     13
  34      200 30960391 30960387      2
  35      202 43111672 30960392      5
  36      208 30960399 43111676      2
  37      210 42949345 30960400      3
  38      216 30960407 42949347      3
  39      224 30960415 30960409      3
  40      232 30960423 30960417      3
  41      240 30960431 30960425      3
  42      248 30960439 30960433      6
  43      256 30960447 30960444      3
  44      264 30960455 30960449      2
  45      266 41079292 30960456      1
  46      272 30960463 41079292      3
  47      275 40779450 30960465      1
####

Another fact, tried to run a 'xfs_bmap' file on my 1TB (not sure if
the output of this command would be relevant to you) and got the
following message:

# xfs_bmap -pv cachefile
xfs_bmap: xfsctl(XFS_IOC_GETBMAPX) iflags=0x4 ["file"]: Unable to
allocate memory


Thanks.
Kelbel Junior

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
