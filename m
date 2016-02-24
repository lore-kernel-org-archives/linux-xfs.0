Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4457E7F77
	for <xfs@oss.sgi.com>; Wed, 24 Feb 2016 16:11:28 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C874530405F
	for <xfs@oss.sgi.com>; Wed, 24 Feb 2016 14:11:27 -0800 (PST)
Received: from mga11.intel.com ([192.55.52.93]) by cuda.sgi.com with ESMTP id
	r1VtvMO3GoazNxaa for <xfs@oss.sgi.com>;
	Wed, 24 Feb 2016 14:11:26 -0800 (PST)
Date: Thu, 25 Feb 2016 06:10:33 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 26/35] block: set op to REQ_OP
Message-ID: <201602250636.ppkpGx7r%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="gBBFr7Ir9EOA20Yy"
Content-Disposition: inline
In-Reply-To: <1456343292-14535-27-git-send-email-mchristi@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: mchristi@redhat.com
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, osd-dev@open-osd.org, ocfs2-devel@oss.oracle.com, linux-scsi@vger.kernel.org, konrad.wilk@oracle.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, philipp.reisner@linbit.com, linux-f2fs-devel@lists.sourceforge.net, linux-raid@vger.kernel.org, dm-devel@redhat.com, target-devel@vger.kernel.org, linux-mtd@lists.infradead.org, kbuild-all@01.org, linux-fsdevel@vger.kernel.org, lars.ellenberg@linbit.com, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, drbd-dev@lists.linbit.com


--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Mike,

[auto build test WARNING on next-20160224]
[cannot apply to dm/for-next v4.5-rc5 v4.5-rc4 v4.5-rc3 v4.5-rc5]
[if your patch is applied to the wrong git tree, please drop us a note to help improving the system]

url:    https://github.com/0day-ci/linux/commits/mchristi-redhat-com/separate-operations-from-flags-in-the-bio-request-structs/20160225-041726
reproduce: make htmldocs

All warnings (new ones prefixed by >>):

   lib/crc32.c:148: warning: No description found for parameter 'tab)[256]'
   lib/crc32.c:148: warning: Excess function parameter 'tab' description in 'crc32_le_generic'
   lib/crc32.c:293: warning: No description found for parameter 'tab)[256]'
   lib/crc32.c:293: warning: Excess function parameter 'tab' description in 'crc32_be_generic'
   lib/crc32.c:1: warning: no structured comments found
>> block/blk-core.c:1248: warning: No description found for parameter 'op'
>> block/blk-core.c:1248: warning: No description found for parameter 'op'

vim +/op +1248 block/blk-core.c

da8303c6 block/blk-core.c          Tejun Heo      2011-10-19  1232   * @q: request_queue to allocate request from
3cbf3506 block/blk-core.c          Mike Christie  2016-02-24  1233   * op: REQ_OP_READ/REQ_OP_WRITE
3cbf3506 block/blk-core.c          Mike Christie  2016-02-24  1234   * @op_flags: rq_flag_bits
da8303c6 block/blk-core.c          Tejun Heo      2011-10-19  1235   * @bio: bio to allocate request for (can be %NULL)
a06e05e6 block/blk-core.c          Tejun Heo      2012-06-04  1236   * @gfp_mask: allocation mask
da8303c6 block/blk-core.c          Tejun Heo      2011-10-19  1237   *
d0164adc block/blk-core.c          Mel Gorman     2015-11-06  1238   * Get a free request from @q.  If %__GFP_DIRECT_RECLAIM is set in @gfp_mask,
d0164adc block/blk-core.c          Mel Gorman     2015-11-06  1239   * this function keeps retrying under memory pressure and fails iff @q is dead.
d6344532 drivers/block/ll_rw_blk.c Nick Piggin    2005-06-28  1240   *
da3dae54 block/blk-core.c          Masanari Iida  2014-09-09  1241   * Must be called with @q->queue_lock held and,
a492f075 block/blk-core.c          Joe Lawrence   2014-08-28  1242   * Returns ERR_PTR on failure, with @q->queue_lock held.
a492f075 block/blk-core.c          Joe Lawrence   2014-08-28  1243   * Returns request pointer on success, with @q->queue_lock *not held*.
^1da177e drivers/block/ll_rw_blk.c Linus Torvalds 2005-04-16  1244   */
3cbf3506 block/blk-core.c          Mike Christie  2016-02-24  1245  static struct request *get_request(struct request_queue *q, int op,
3cbf3506 block/blk-core.c          Mike Christie  2016-02-24  1246  				   int op_flags, struct bio *bio,
3cbf3506 block/blk-core.c          Mike Christie  2016-02-24  1247  				   gfp_t gfp_mask)
^1da177e drivers/block/ll_rw_blk.c Linus Torvalds 2005-04-16 @1248  {
3cbf3506 block/blk-core.c          Mike Christie  2016-02-24  1249  	const bool is_sync = rw_is_sync(op, op_flags) != 0;
450991bc drivers/block/ll_rw_blk.c Nick Piggin    2005-06-28  1250  	DEFINE_WAIT(wait);
a051661c block/blk-core.c          Tejun Heo      2012-06-26  1251  	struct request_list *rl;
a06e05e6 block/blk-core.c          Tejun Heo      2012-06-04  1252  	struct request *rq;
a051661c block/blk-core.c          Tejun Heo      2012-06-26  1253  
a051661c block/blk-core.c          Tejun Heo      2012-06-26  1254  	rl = blk_get_rl(q, bio);	/* transferred to @rq on success */
a06e05e6 block/blk-core.c          Tejun Heo      2012-06-04  1255  retry:
3cbf3506 block/blk-core.c          Mike Christie  2016-02-24  1256  	rq = __get_request(rl, op, op_flags, bio, gfp_mask);

:::::: The code at line 1248 was first introduced by commit
:::::: 1da177e4c3f41524e886b7f1b8a0c1fc7321cac2 Linux-2.6.12-rc2

:::::: TO: Linus Torvalds <torvalds@ppc970.osdl.org>
:::::: CC: Linus Torvalds <torvalds@ppc970.osdl.org>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--gBBFr7Ir9EOA20Yy
Content-Type: application/octet-stream
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

H4sICIonzlYAAy5jb25maWcAjDzbcts4su/7FazMeZipOrnZjjdTp/wAgaCIEUkwBCnJfmFp
ZDpRjS15dZlJ/v50A6R4ayi7VVMboxsg0Oh7N/TLv37x2Om4e1kdN+vV8/MP72u1rfarY/Xo
PW2eq//zfOUlKveEL/N3gBxttqfv7zfXn2+9m3ef3n14u19/8mbVfls9e3y3fdp8PcHszW77
r18Am6skkNPy9mYic29z8La7o3eojv+qx5efb8vrq7sfnb/bP2Si86zguVRJ6QuufJG1QFXk
aZGXgcpilt+9qZ6frq/e4q7eNBgs4yHMC+yfd29W+/W3998/375fm10ezBnKx+rJ/n2eFyk+
80Va6iJNVZa3n9Q547M8Y1yMYXFctH+YL8cxS8ss8Us4uS5jmdx9vgRny7uPtzQCV3HK8p+u
00PrLZcI4Zd6WvoxKyORTPOw3etUJCKTvJSaIXwMCBdCTsN8eDp2X4ZsLsqUl4HPW2i20CIu
lzycMt8vWTRVmczDeLwuZ5GcZCwXcEcRux+sHzJd8rQoM4AtKRjjoSgjmcBdyAfRYphNaZEX
aZmKzKzBMtE5lyFGAxLxBP4KZKbzkodFMnPgpWwqaDS7IzkRWcIMp6ZKazmJxABFFzoVcEsO
8IIleRkW8JU0hrsKYc8UhiEeiwxmHk1G3zBcqUuV5jIGsvggQ0AjmUxdmL6YFFNzPBYB4/ck
ESSzjNjDfTnVw/Nanih5EDEAvnn7hKrj7WH1d/X4tlp/9/oDj9/f0F8v0kxNRGf1QC5LwbLo
Hv4uY9Fhm3SaMyAb8O9cRPruqhk/CzgwgwZF8P558+f7l93j6bk6vP+fImGxQCYSTIv37waS
LrMv5UJlnducFDLygXaiFEv7PW3F3CizqdGMz6jATq8w0kzK1EwkJexYx2lXfcm8FMkczoyb
i2V+d33eNs+AD4zISuCFN29aVVmPlbnQlMaES2LRXGQaeK03rwsoWZErYrIRjhmwqojK6YNM
B2JTQyYAuaJB0UNXRXQhywfXDOUC3LSA/p7OZ+puqHucIQJu6xJ8+XB5troMviFICXzHighk
Vukcmezuza/b3bb6rXMj+l7PZcrJte39A4er7L5kOViWkMQLQpb4kSBhhRagQl3XbCSNFWC1
YR/AGlHDxcD13uH05+HH4Vi9tFx8NgQgFEYsCRsBIB2qRYfHYQRMMAdNk4egZv2eqtEpy7RA
pHaMo3nVqoA5oNJyHvpqqJy6KD7LGT15DvbDR/MRMdTK9zwidmxEed4SYGiDcD1QKEmuLwLR
7JbM/6PQOYEXK9RkuJeGxPnmpdofKCqHD2hTpPIl7zJ6ohAiXTdtwCQkBD0M+k2bk2a6i2P9
r7R4n68Of3lH2JK32j56h+PqePBW6/XutD1utl/bveWSz6zB5FwVSW7v8vwpvGtDzxY8+lzG
C0+PTw249yXAusvBn6BkgRiUltMD5JzpmcYpJBFwKXDOogiVZ6wSEinPhDCYxoNzroNbApkR
5USpnMQyNgLcrOSKFm05s/9wCWYBbq01LeDC+JbNumfl00wVqabVRij4LFUSXAG49Fxl9EHs
ymgEzFr0YdHrog8YzUC9zY0By3x6H/zsY6D8Gx+MOC9LwBbJBDx3PTAChfQ/dlx9lNA8AuJz
kRovylzSYE7KdTrLyjRiObr9LdSyUZeGMahmCfoxo8kDzlMMHFXWioFGuteBvogxA4C+j+mb
aoAlm2gVFcBQsEcQLhI5zeBGZw5um9JT+sSg54LTUwaFY/sBbGpJQkSqXESR04RFAc0URgU5
YEaPOmCTNLh8EyHYSRLCJG25mT+XcPR6UfqCkDuMCXfsCr45YVkm+zzUHAfjBl/4Qw6FJcuz
PTEasY6M02r/tNu/rLbryhN/V1tQwQyUMUclDKaiVZX9Jc67qf10BMLGy3ls3HVy4/PYzi+N
lh4YhZ6bidFiRrOdjhjlWeiomHS3pSM1cUlPDnEgmu8SnFIZSG7CIwf7q0BGA3vSpauyGB2F
0IyUSSwt43W39UcRp+AXTATNUHXYQRtU/J5JV0DwCtyOepRzobVrbyKAs0mkNwQbvRkDtwbv
DW0HGMNyohds6H1L0OYYy8Pm8gFoNoyT7GgmchIAqpmeYEcxUgkoBQu0HIyYjRvUUKnZAIjp
BPg7l9NCFYQDBdGQcWlq15CIZyH+vAfnGR01o45NumfwlUxMQYlC5GzSLzVpS5YOt4q7gVEr
KQNYuABGF8xazgEslku4sRaszReH5gqUBYznRZaAM5YDO3dzUUPZJwhpoMTCjURn9fH8Ih7y
haFWy9GjZIi9uFKzQIAvmmLqZbhCzZaWvibaH2DU82wQ6YD5qnDkLSDIKa2r3wSmxAm04Khz
IMSP8hHxwJ8w50feFxz8mp5DNAQSojjCgWtKxMVV8DqKiNEuwhgbiKfcGopwjh2ilGBUJOps
T/8qYuUXEcgnagoRIb+Mb1tbCAiEiseJr3Fm8VJWss0k2ktQ6X0tq2UedWaCi5qA7gJyLFjm
dwAKHGFwCerc1vUIwEzy9pw+4Wr+9s/VoXr0/rJW8XW/e9o894KQ8zERu2y0fC96M5ttlIxV
QqFAknbyOOj5aDSSdx87Jt3Sl7jDhvImSIhA1RW9PMQEfXRimsmuwYdSUOlFgkj9YLeGG4pa
+CUYOXeRYTDimNwF9mf382wsV6hks3gxwEBO+1KIApUDHMKE126UbNEgtE4kEOyh7yKZu073
u3V1OOz23vHHqw08n6rV8bSvDt26wAMylu9I3oD9IMcxNRkIBsoYNB+LHYbcYGFqoEHFhBqN
OgV2DaSmMzC4jljmwN+YD77kbtcpU5lJ+jM2KoObgD1lmJc09sYRo4T3YBrAiwXNMy3oVGCi
TJBq06Qtk998vqUd2k8XALmmnUmExfGSEplbU6tpMUEFQMwVS0kvdAZfhtOkbaA3NHTmONjs
347xz/Q4zwqt6JA6Nn6ecHiw8UImPAQ76NhIDb52hRoRc6w7FRA8T5cfL0DLiI7iYn6fyaWT
3nPJ+HVJp1UN0EE7Dm6qYxaqGadk1ArbUQQ0goCJgrqyo0MZ5HefuijRxwGst3wKpgJEPeFU
HgIRUI8ZJJND0UUnf4BgEID+QO323N4Mh9W8PxLLRMZFbDJnATiz0X1/38Yh5XkU655XA1tB
TxY9CxGBi0E5NbAi6HBDnI79a4bN/fbKpw2ExT6BDiLEimwMME5JLCBSo9YqYm7HW9WUitzG
XORl+7GklJUppGkwx+fzCxGn+chPa8bnKgI/imV0jqrGcnIbEiGVtE4zl+ZIARpGE+C43EMc
7dCXTkCugDUntDGTn+lAGz+YCdTjgVy60n5gvIFbQDrc59H0ZRiWTQtJK55EYf54kF1pbtlC
bno54Hrw9oZyhOexTiMwbte9Ke0oxqUOglqUKzrV1YJ/usJHal+meKuCQIv87sN3/sH+b3DO
gdcTgKGH0VIkjKjlmmDHDTby3BR3wLXsCq+MkL2ixvZjGaMQd+fdXJzbbCpmSWHCtNa1OO/I
wggq1JP7q5VG5dp5nbizXQ6CoFx2NKMNmUU86fujveF60e6CthdDag7xQ3d6P+1SezOg7wJl
FqEyUOae09x8yGiUm0FSi7vzTOE9+MK+n5W5syOl8UiRPNP2XuYyA50HDlfRc39nmhKdpjZo
gi1bOvKzu5sPv992yxHjSJBSm90uhFnP0eORYImxiHQE6/CqH1Kl6LTYw6Sg1cSDHqcbG9e5
DsNM0b5JYbmbDQKRZf1EhKky9EphmbkDfXa6nXWvNHfrQ2PkIchVWGTPsiIdMkVP/WpwtTHu
W9zddrgpzjNaqZpT2RDcuQEgmTt6MQYdnFracaszJfS5H8qPHz5Q6vqhvPr0oSdSD+V1H3Ww
Cr3MHSwzjFnCDGuDdJ1DLIWrxM10aBJalE4GUZQc9CAomAzV8sdaK3frU4ozUym7NN/ktmD+
1WB6nd+e+5ouEfDYNyH0xCUNoHtlcF9Gfk4VJ7qcYI1Ao7NDlaeRyUDaQHj3T7X3Xlbb1dfq
pdoeTSjMeCq93St2yfXC4TqRQisvmtd00PO2mqKvF+yr/5yq7fqHd1iv6hRLe3h0VTPxhZwp
H5+rIbKzMm0IgEpKn/Gw7pBGfbk1601Oh+bQ3q8pl151XL/7rfspHCSyLLY1rc75th6VdqQN
ODIDCVKRox0DuIiWxUTknz59oMOvlKM5c2uAex1MRkQQ36v16bj687ky7ZWeqQodD957T7yc
nlcjlpiAMYxzTPrRtTML1jyTKWXObFZQFT0VW0/C4UuLxtKRFMAQ0CHX9ns23SSVtQVdYo7o
4Vd/b9aV5+83f9s6WNtptVnXw54ai0pha1yhiFJXHCLmeZwGjlxMDuqbYV7TFV6Y5QOZxQsw
0rboT6IGCzAczHdsAu3mwlTTKaINynt+JufOwxgEMc8c6S7gtk7OiE5zNQ0rIKiwkuRkKrSL
hR0ETS9QJ75jtkHRB6oEAZH8Q0F/NPfau7I4pymoAmIbNlttugybPlPwluqm2/ae7NBoB/Hm
sKa2ABcQ32OmlNyISHikNOYK0SEY0qcldcZoXcyvyM0IATSMvcPp9XW3P3a3YyHl79d8eTua
llffVwdPbg/H/enFVIwP31b76tE77lfbAy7lgV6vvEc46+YV/9lID3s+VvuVF6RTBkpm//IP
TPMed/9sn3erR882Rza4cnusnj0QV3NrVt4amOYyIIbnKiVG24XC3eHoBPLV/pH6jBN/93pO
Jevj6lh5cWtLf+VKx78NlQfu77xcS2seOjyBZWTqBU5g3QcI5seJIkToUobSP7eFaa5lzZUd
bjibLS3R6eiFdTjmSo/HjIMfqdDHMnpj3Pwlt6+n4/iDrQVN0mLMriHckOEY+V55OKXvomD3
2n8nrwa1e5wpiwUpIRwYe7UGpqVkNs/pFBCoMFdfCIBmLphMY1narkpH5n1xybdP5i7pT/nn
f1/ffi+nqaMrJdHcDYQdTW3Q4s6s5Rz+c/iBEFDwYZXKMsEVJ+/e0b2mHVyu05gGhHrsgKap
pr6ZpmMexbH6xcnOtEw2syw0T73182791xAgtsaFgjAAW2DRpwbnAnu5MTIwJAQLH6fYU3Lc
wdcq7/it8laPjxv0JFbPdtXDu0Hh0ZSzlQkWIbbAy4Lleyxsh0hKLBxuolpgeR+C4MiRyzQI
GIXS7piFs7mjYWXh7HgMRRYzOrppWm+pDIuedF8pWM21227WB09vnjfr3dabrNZ/vT6vtr04
AeYRq004uAvD5SZ7METr3Yt3eK3Wmydw9Fg8YT23d5C+sFb99HzcPJ22a7zDRq89npV/qxkD
37hbtNpEYKZ06Qhbwxw9DQgur53TZyJOHd4gguP89vp3R/UEwDp2BRRssvz04cPlrWMs6ipC
ATiXJYuvrz8tsaDBfEdRDxFjhyKyXRG5w4eMhS9Zk9EZXdB0v3r9hoxCCL/fr5paR4Wn7jdj
MAELGSUiDScG+9VL5f15enoCm+GPbUZASyi2METGRkXcp07RJpSnDFOfjvZaVfSD9CYmAclR
IZdlJPMcAmEI5SXrNMMgfPRyDAfPTQ8h79n/Qo8DSBwzzt9j3+vB8fTbjwO+4vOi1Q80pmPR
wK+BhqTtk0oNfMmFnJMYCJ0yf+pQVMWCJnscO/hQxNqZWEoEBFbCp5We7QKTEwmUviduQviM
N2EoxMZF56WUAbW30PqHME6slIE6GNgAHOIR0/TWwF0jgqt258XSlzp19V4XDqk0+WeXnzff
7EF4qOvGaVLBBfSXrWOk9X532D0dvfDHa7V/O/e+nirw3AnZBVGYDtoze6mOpi2CCitbPzmE
WEecccfHODue+nWzNUZ/wOLcDOrdad/T+8360UxnvJSfrz51OpFgVMxzYnQS+efR9nbyGDz9
VNL8Da62cc5KHv8EIc4LukZ+xshjuhVcxDUCSIbD7ZfRRNHZKqniuHBq56x62R0rDKcoVtG5
MPWmuMywND2e/fpy+Dq8EQ2Iv2rz2sNTW/DjN6+/tUZ9EJfp1cvhtP1qJtl1SF4rkqV0x9gw
uXRQJjX8N8xrtpRd5k7LaVK3NEkdApkuqMoPAxmYgs6J2bJMsm7vmUyxvXNS0LJhnD/TTJup
yBWYBPH4VlCXdx/cjJI9LmWPbnK6ZOXV5yRGH57W0D0s0P40U4OzVs7AYzYY7i+iG8sdVZGY
jy1dt2f+BRxQCBAohsnYWJWw7eN+t3nsokFIlylXHdwZSercEUWaCk4ejr5ski49nwbuZ7Rn
gzWa2qRq/LF0Ct+RfWwSlHAAV8XJF1FUZhNa3/jcnzBXW5yaRuL8CWK/EIFZzuuoYd826UAs
1umDb/erMRiQSwA5XqVguycGsi57E2jTgO3ICVyASQsrnc+CAnZh9pdC5XQexkB4Th8HM6iB
vikdaegAu5IcMAW2HtyEAdgyxWr9beDw6lEl2MrQoTo97kypob2pViRB0bs+b2A8lJGfCVpr
Yl7MlV7Hx1N0eGVfrl+GlsNqeOtEmP8DLnIsgDULw0P2AQqNlERjktbvdL5BZNt/FGl+70Fm
X8xT947jaGa97jfb418m//D4UoF9bIt6Z9OiNZa5I5SlOeiMujng7qa+yt3LK1zOW/M+E251
/dfBLLe243uqTGiLAdglQRs6W48EmcXfzUgzwSGQcTzLqkuXhflhA0E2OdteVVzt7uOHq5uu
bsxkWjIdl85XcNjdbL7ANK1HiwQkAKPaeKIcD7Vs+84iuVgZCahSRiiwLqPtycavqbSwvy0C
PBNjOoTm5AGSJatKIirsaHNIvQbfQcf0z1p/6xMp80RasFnT/+FwB9HfAG7v1zR6S9kEdsOz
MbiB+x8QNf95+vp1UBg2tDaNF9rVRDP4xQj3lcERtUpcatwuoyZ/AH2db6vq7YNti4AO4xts
IBe+YJ/VFNqlUCzW3JVHNkAIogpHHs1i1KV/bGW5gHWh1649rNkvqv4gMg/tqeM0YNdKhg2R
NiPGPw9eolg4qI/VdVpgFy+CAOz0ajVUuNp+7akltNpFCquMX+l0PoFA0POJfdRNJye/kPnJ
DnslwPMglEqlFO/04MMOOwvEGAur4qNWF6dWtWDLTvhDLj8jI35hJkRKPZNHMrYC6P16qAPe
w/96L6dj9b2Cf2BzxLt+e0R9P/VDjUv8iE97HWG4xVgsLBK+4FykLKeVn8U1rXYXhD1T88su
m1kA02kXPtIkayIg2U/2Ap8xL/20iAL3ow7zUWDD89sPh3/f/KbThY/OrJq6tC3pWL/WlvJn
GPqSlmxeHF66UJ4JH99IMMK3wd9NoNW9uTrXzyrUP9+Bv4pwyVz9lMZmAXzneBHjv1rmJ7/d
8KX+QaNLjF//YEmZuW1qQ+9SZJnKQCX8IdxNpbbVk8TpegWY3W1UOMTluX30aZ7c2QcJlK4n
EYkvtA9IHT9PZsxCUCS8/XGF4RPMM3SasTT8r3CC1NzW8CFu/aSXfGLcB5YLmYfUs9gaHJu3
lIDAIZocoNRNeXaj9uXu8FFpPdGu0gJxBuoQIgkcjBjMChD+VAr453l1OA5ECAlghNv8UhSd
HmnvBd9uuhl8Yp4fOuFWRd7enBUfLY64oVD8fx/XstwgDAN/pZ+QNJdesYHUDQUGTCbkwrSd
HHLqDNMc8veVZGIwkXxMVjwS25Isa/ck9hqRAc6tcj+1T/F+hewOYGiFaiMZkHQF35tGuDJW
qksQ3sDCeJe6PJ3USlrptgnkcgKut3zvLhU1TiAPkmNC8lnzNNFFdrVPgzMB/Bxb+p1qkxLu
DBkiaqY4Puu8C0I07jmO1BjfuoayLOwScX4i0g+BNXrIGVXVuiZ7QRLGNXFHxEio1m9xZsmH
lLNNxAs3FSpD8AZEMyevGsuuCpUXnUDZnMrgsJpk2QY8EhGcpamcJOFg+zobNqe3zZw9rjEY
iS2Puck3C9WFKLGedk8YPWzZ4zoDwg7eW0Qmu7cpV/2O/i+dgtjyFZepsa6TyFrzSkAPscHI
uEGKIhTaPVUOwoqgktOhoh56weeXcQcMl5/beP27czWTQ9YLpapMd42xPTiVrKVKPC2nqC1b
bXj8i/MNkwVxZo2Gmn9NX0cE+44B72PajpqzLKiiTJk0PeOb3e7j+j1+jfeX8fcG0eyyKFZ5
5Q7blBoSjhy7EzG5YMQ9wKTISgHNTfmQ1VSG0UyrtfHtwStI/JqRQiB+N2k91YUJJWB0owet
jeUHEtAtz+HD6+x2kxo+piFsLCSiErrjj0gA4TtCCqPoKolDoXmqMgCQCGQSyYd0/yY1PUeE
YOi3c+JB7W6713hicTqjCm8EGpT+YOdwi4O6pJ65r9DrhjQxCnVLhUk/0j73weeYnA4RrDmG
Ch+Q6wm/ME35vQuJHYpiVxPbLBaYWzzXTkzJvDJGmIGCFID/lLLC2GdZAAA=

--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--gBBFr7Ir9EOA20Yy--
