Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F26EC7F6F
	for <xfs@oss.sgi.com>; Thu, 31 Oct 2013 12:15:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E075D8F8059
	for <xfs@oss.sgi.com>; Thu, 31 Oct 2013 10:14:57 -0700 (PDT)
Received: from server506.appriver.com (server506h.appriver.com [50.56.144.38])
	by cuda.sgi.com with ESMTP id SXMicDKNgT1FxAAW (version=TLSv1
	cipher=DES-CBC3-SHA bits=168 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 31 Oct 2013 10:14:54 -0700 (PDT)
Subject: Re: [PATCH 04/23] block: Abstract out bvec iterator
MIME-Version: 1.0 (Apple Message framework v1085)
From: Ed Cashin <ecashin@coraid.com>
In-Reply-To: <1383077896-4132-5-git-send-email-kmo@daterainc.com>
Date: Thu, 31 Oct 2013 13:14:48 -0400
Message-ID: <B60197FE-BC53-4EBA-8F78-02E4D9D31844@coraid.com>
References: <1383077896-4132-1-git-send-email-kmo@daterainc.com>
	<1383077896-4132-5-git-send-email-kmo@daterainc.com>
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
To: Kent Overstreet <kmo@daterainc.com>
Cc: Dave Kleikamp <shaggy@kernel.org>, Jeremy Fitzhardinge <jeremy@goop.org>, Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>, Jan Beulich <jbeulich@suse.com>, Mike Snitzer <snitzer@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Neil Brown <neilb@suse.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Selvan Mani <smani@micron.com>, Namjae Jeon <namjae.jeon@samsung.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Chris Mason <chris.mason@fusionio.com>, nab@linux-iscsi.org, dm-devel@redhat.com, Paul Mackerras <paulus@samba.org>, Pavel Machek <pavel@ucw.cz>, KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>, Ian Campbell <Ian.Campbell@citrix.com>, Joshua Morris <josh.h.morris@us.ibm.com>, Alasdair Kergon <agk@redhat.com>, Nick Piggin <npiggin@kernel.dk>, =?iso-8859-1?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>, Joe Perches <joe@perches.com>, Len Brown <len.brown@intel.com>, Minchan Kim <minchan@kernel.org>, Jie Liu <jeff.liu@oracle.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Stefano Stabellini <stefano.stabellini@eu.citrix.com>, Sebastian Ott <sebott@linux.vnet.ibm.com>, Philip Kelleher <pjk1939@linux.vnet.ibm.com>, Steven Whitehouse <swhiteho@redhat.com>, hch@infradead.org, Christian Borntraeger <borntraeger@de.ibm.com>, Ingo Molnar <mingo@redhat.com>, Geert Uytterhoeven <geert@linux-m68k.org>, Mel Gorman <mgorman@suse.de>, Boaz Harrosh <bharrosh@panasas.com>, Matthew Wilcox <willy@linux.intel.com>, Lars Ellenberg <drbd-dev@lists.linbit.com>, Ben Hutchings <ben@decadent.org.uk>, Prasad Joshi <prasadjoshi.linux@gmail.com>, Nitin Gupta <ngupta@vflare.org>, Alex Elder <elder@inktank.com>, Dan Magenheimer <dan.magenheimer@oracle.com>, Peng Tao <tao.peng@emc.com>, Sage Weil <sage@inktank.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Pankaj Kumar <pankaj.km@samsung.com>, Trond Myklebust <Trond.Myklebust@netapp.com>, Joern Engel <joern@logfs.org>, Rusty Russell <rusty@rustcorp.com.au>, Steven Rostedt <rostedt@goodmis.org>, xfs@oss.sgi.com, "Rafael J. Wysocki" <rjw@sisk.pl>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Ben Myers <bpm@sgi.com>, Jerome Marchand <jmarchand@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Andy Adamson <andros@netapp.com>, Sam Bradshaw <sbradshaw@micron.com>, Jaegeuk Kim <jaegeuk.kim@samsung.com>, ceph-devel@vger.kernel.org, Yehuda Sadeh <yehuda@inktank.com>, axboe@kernel.dk, Theodore Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sunil Mushran <sunil.mushran@gmail.com>, Geoff Levand <geoff@infradead.org>, Jiri Kosina <jkosina@suse.cz>, Asai Thambi S P <asamymuthupa@micron.com>, linux-kernel@vger.kernel.org, "James E.J.
	Bottomley" <JBottomley@parallels.com>, fanchaoting <fanchaoting@cn.fujitsu.com>, Benny Halevy <bhalevy@tonian.com>, Jiang Liu <jiang.liu@huawei.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, tj@kernel.org, linux390@de.ibm.com, Mark Fasheh <mfasheh@suse.com>, Wei Yongjun <yongjun_wei@trendmicro.com.cn>, Frederic Weisbecker <fweisbec@gmail.com>, Guo Chao <yan@linux.vnet.ibm.com>, Joel Becker <jlbec@evilplan.org>

On Oct 29, 2013, at 4:17 PM, Kent Overstreet wrote:

> Immutable biovecs are going to require an explicit iterator. To
> implement immutable bvecs, a later patch is going to add a bi_bvec_done
> member to this struct; for now, this patch effectively just renames
> things.

Ack.  These patches pass sanity-check testing, too, for aoe.

-- 
  Ed Cashin
  ecashin@coraid.com


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
