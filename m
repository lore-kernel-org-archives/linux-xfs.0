Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 26C677F5E
	for <xfs@oss.sgi.com>; Fri, 17 Jan 2014 02:00:31 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 11C11304087
	for <xfs@oss.sgi.com>; Fri, 17 Jan 2014 00:00:28 -0800 (PST)
Received: from mail-pa0-f43.google.com (mail-pa0-f43.google.com
	[209.85.220.43]) by cuda.sgi.com with ESMTP id FFtYPMPMLrBoLLOk
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 17 Jan 2014 00:00:14 -0800 (PST)
Received: by mail-pa0-f43.google.com with SMTP id rd3so3821312pab.2
	for <xfs@oss.sgi.com>; Fri, 17 Jan 2014 00:00:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1385513128-5035-4-git-send-email-kmo@daterainc.com>
References: <20131127004422.GB21305@kmo>
	<1385513128-5035-1-git-send-email-kmo@daterainc.com>
	<1385513128-5035-4-git-send-email-kmo@daterainc.com>
Date: Fri, 17 Jan 2014 09:00:13 +0100
Message-ID: <CAMuHMdUmTqZSAiwYc0Uc=u1YrCZUJeFAuR7PeZqBvWqnqUwmLQ@mail.gmail.com>
Subject: Re: [PATCH 04/25] block: Abstract out bvec iterator
From: Geert Uytterhoeven <geert@linux-m68k.org>
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
Cc: Dave Kleikamp <shaggy@kernel.org>, Jeremy Fitzhardinge <jeremy@goop.org>, Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>, Jan Beulich <jbeulich@suse.com>, "Ed L. Cashin" <ecashin@coraid.com>, "Michael S. Tsirkin" <mst@redhat.com>, Neil Brown <neilb@suse.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Selvan Mani <smani@micron.com>, Namjae Jeon <namjae.jeon@samsung.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Chris Mason <chris.mason@fusionio.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, dm-devel@redhat.com, Paul Mackerras <paulus@samba.org>, Pavel Machek <pavel@ucw.cz>, KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>, Ian Campbell <Ian.Campbell@citrix.com>, Joshua Morris <josh.h.morris@us.ibm.com>, Alasdair Kergon <agk@redhat.com>, Sage Weil <sage@inktank.com>, =?UTF-8?Q?Roger_Pau_Monn=C3=A9?= <roger.pau@citrix.com>, Joe Perches <joe@perches.com>, Mike Snitzer <snitzer@redhat.com>, Len Brown <len.brown@intel.com>, Minchan Kim <minchan@kernel.org>, Jie Liu <jeff.liu@oracle.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Stefano Stabellini <stefano.stabellini@eu.citrix.com>, Sebastian Ott <sebott@linux.vnet.ibm.com>, Philip Kelleher <pjk1939@linux.vnet.ibm.com>, Steven Whitehouse <swhiteho@redhat.com>, Christoph Hellwig <hch@infradead.org>, Christian Borntraeger <borntraeger@de.ibm.com>, Ingo Molnar <mingo@redhat.com>, Mel Gorman <mgorman@suse.de>, Boaz Harrosh <bharrosh@panasas.com>, Matthew Wilcox <willy@linux.intel.com>, Lars Ellenberg <drbd-dev@lists.linbit.com>, Ben Hutchings <ben@decadent.org.uk>, Prasad Joshi <prasadjoshi.linux@gmail.com>, Nitin Gupta <ngupta@vflare.org>, Alex Elder <elder@inktank.com>, Dan Magenheimer <dan.magenheimer@oracle.com>, Peng Tao <tao.peng@emc.com>, Nick Piggin <npiggin@kernel.dk>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Pankaj Kumar <pankaj.km@samsung.com>, Trond Myklebust <Trond.Myklebust@netapp.com>, Joern Engel <joern@logfs.org>, Rusty Russell <rusty@rustcorp.com.au>, Steven Rostedt <rostedt@goodmis.org>, xfs@oss.sgi.com, "Rafael J. Wysocki" <rjw@sisk.pl>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Ben Myers <bpm@sgi.com>, Jerome Marchand <jmarchand@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Andy Adamson <andros@netapp.com>, Sam Bradshaw <sbradshaw@micron.com>, Jaegeuk Kim <jaegeuk.kim@samsung.com>, ceph-devel@vger.kernel.org, Yehuda Sadeh <yehuda@inktank.com>, Jens Axboe <axboe@kernel.dk>, Theodore Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sunil Mushran <sunil.mushran@gmail.com>, Geoff Levand <geoff@infradead.org>, Jiri Kosina <jkosina@suse.cz>, Asai Thambi S P <asamymuthupa@micron.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, fanchaoting <fanchaoting@cn.fujitsu.com>, Benny Halevy <bhalevy@tonian.com>, Tejun Heo <tj@kernel.org>, Jiang Liu <jiang.liu@huawei.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux390@de.ibm.com, Mark Fasheh <mfasheh@suse.com>, Wei Yongjun <yongjun_wei@trendmicro.com.cn>, Frederic Weisbecker <fweisbec@gmail.com>, Guo Chao <yan@linux.vnet.ibm.com>, Joel Becker <jlbec@evilplan.org>

On Wed, Nov 27, 2013 at 1:45 AM, Kent Overstreet <kmo@daterainc.com> wrote:
> Immutable biovecs are going to require an explicit iterator. To
> implement immutable bvecs, a later patch is going to add a bi_bvec_done
> member to this struct; for now, this patch effectively just renames
> things.

You missed xtensa simdisk:

arch/xtensa/platforms/iss/simdisk.c:108:23: error: 'struct bio' has no
member named 'bi_sector'

http://kisskb.ellerman.id.au/kisskb/buildresult/10477507/

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
