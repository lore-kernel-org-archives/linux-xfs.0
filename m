Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1EMZjq6019568 for <xfs@oss.sgi.com>; Sat, 14 Feb 2009 16:35:46 -0600
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E381D120D18
	for <xfs@oss.sgi.com>; Sat, 14 Feb 2009 14:35:09 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id Uo4QqDGNLtj9tKP9 for <xfs@oss.sgi.com>;
	Sat, 14 Feb 2009 14:35:09 -0800 (PST)
Message-ID: <49972260.4000702@sandeen.net>
Date: Sat, 14 Feb 2009 13:58:24 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: add "quick" group
References: <20090214164245.GD19813@infradead.org>
In-Reply-To: <20090214164245.GD19813@infradead.org>
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
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> Add a new group for test to quickly verify WIP patches.  I've started
> it by only taking tests fro mthe auto group that take 20 seconds or less
> to complete on the kvm virtual machine on my laptop.  The total run
> of the quick group takes about 8 minutes for me.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Good plan, couple comments:

should quick only be a subset auto tests or are they orthogonal?

A few tests you've flagged as quick don't met the 20s criteria on my
box, just FWIW; may be filesystem-size specific:

013 57
028 23
031 21
049 36
075 36
076 56
078 20
091 26
112 38
113 55
178 363

Most are probably close enough, but 178 looks nasty - seems to be
xfs_repair that's taking so long.  These are running on 100G partitions,
though :)

-Eric

> Index: xfstests-dev/group
> ===================================================================
> --- xfstests-dev.orig/group	2009-02-14 16:06:31.000000000 +0000
> +++ xfstests-dev/group	2009-02-14 16:36:45.000000000 +0000
> @@ -103,40 +103,40 @@
>  
>  # test-group association ... one line per test
>  #
> -001 rw dir udf auto
> -002 metadata udf auto
> -003 db auto
> -004 db auto
> -005 dir udf auto
> -006 dir udf auto
> -007 dir udf auto
> -008 rw ioctl auto
> -009 rw ioctl auto
> +001 rw dir udf auto quick
> +002 metadata udf auto quick
> +003 db auto quick
> +004 db auto quick
> +005 dir udf auto quick
> +006 dir udf auto quick
> +007 dir udf auto quick
> +008 rw ioctl auto quick
> +009 rw ioctl auto quick
>  010 other udf auto
> -011 dir udf auto
> -012 rw auto
> -013 other ioctl udf auto
> -014 rw udf auto
> -015 other auto
> -016 rw auto
> -017 mount auto
> -018 log logprint v2log auto
> -019 mkfs auto
> -020 metadata attr udf auto
> -021 db attr auto
> +011 dir udf auto quick
> +012 rw auto quick
> +013 other ioctl udf auto quick
> +014 rw udf auto quick
> +015 other auto quick
> +016 rw auto quick
> +017 mount auto quick
> +018 log logprint v2log auto quick
> +019 mkfs auto quick
> +020 metadata attr udf auto quick
> +021 db attr auto quick
>  022 dump ioctl tape
>  023 dump ioctl tape
>  024 dump ioctl tape
>  025 dump ioctl tape
> -026 dump ioctl auto
> -027 dump ioctl auto
> -028 dump ioctl auto
> -029 mkfs logprint log auto
> -030 repair auto
> -031 repair mkfs auto
> -032 mkfs auto
> -033 repair auto
> -034 other auto
> +026 dump ioctl auto quick
> +027 dump ioctl auto quick
> +028 dump ioctl auto quick
> +029 mkfs logprint log auto quick
> +030 repair auto quick
> +031 repair mkfs auto quick
> +032 mkfs auto quick
> +033 repair auto quick
> +034 other auto quick
>  035 dump ioctl tape auto
>  036 dump ioctl remote tape
>  037 dump ioctl remote tape
> @@ -147,103 +147,103 @@
>  042 fsr ioctl auto
>  043 dump ioctl tape
>  044 other auto
> -045 other auto
> -046 dump ioctl auto
> +045 other auto quick
> +046 dump ioctl auto quick
>  047 dump ioctl auto
> -048 other auto
> -049 rw auto
> -050 quota auto
> -051 acl udf auto
> -052 quota db auto
> -053 acl repair auto
> -054 quota auto
> +048 other auto quick
> +049 rw auto quick
> +050 quota auto quick
> +051 acl udf auto quick
> +052 quota db auto quick
> +053 acl repair auto quick
> +054 quota auto quick
>  055 dump ioctl remote tape
> -056 dump ioctl auto
> +056 dump ioctl auto quick
>  057 acl auto
>  058 acl auto
>  059 dump ioctl
>  060 dump ioctl
> -061 dump ioctl auto
> -062 attr udf auto
> -063 dump attr auto
> +061 dump ioctl auto quick
> +062 attr udf auto quick
> +063 dump attr auto quick
>  064 dump auto
>  065 dump auto
> -066 dump ioctl auto
> -067 acl attr auto
> +066 dump ioctl auto quick
> +067 acl attr auto quick
>  068 other auto
> -069 rw udf auto
> -070 attr udf auto
> +069 rw udf auto quick
> +070 attr udf auto quick
>  071 rw
> -072 rw auto
> +072 rw auto quick
>  073 copy auto
>  074 rw udf auto
> -075 rw udf auto
> -076 metadata rw udf auto
> +075 rw udf auto quick
> +076 metadata rw udf auto quick
>  077 acl attr auto
> -078 growfs auto
> -079 acl attr ioctl metadata auto
> +078 growfs auto quick
> +079 acl attr ioctl metadata auto quick
>  080 rw ioctl
> -081 log logprint quota auto
> -082 log logprint v2log auto
> +081 log logprint quota auto quick
> +082 log logprint v2log auto quick
>  083 rw auto
>  084 ioctl rw auto
> -085 log auto
> +085 log auto quick
>  086 log v2log auto
>  087 log v2log auto
> -088 perms auto
> +088 perms auto quick
>  089 metadata auto
>  090 rw auto
> -091 rw auto
> -092 other auto
> +091 rw auto quick
> +092 other auto quick
>  093 attr cap udf auto
>  094 metadata dir ioctl auto
>  095 log v2log auto
> -096 mkfs v2log auto
> +096 mkfs v2log auto quick
>  097 udf auto
>  098 udf auto
>  099 udf auto
>  100 udf auto
>  101 udf
>  102 udf
> -103 metadata dir ioctl auto
> +103 metadata dir ioctl auto quick
>  104 growfs ioctl
> -105 acl auto
> +105 acl auto quick
>  106 quota
>  107 quota
>  108 quota
>  109 metadata auto
>  110 repair auto
>  111 ioctl
> -112 rw aio auto
> -113 rw aio auto
> +112 rw aio auto quick
> +113 rw aio auto quick
>  114 parent attr
>  115 parent attr
> -116 quota auto
> -117 attr auto
> -118 quota auto
> +116 quota auto quick
> +117 attr auto quick
> +118 quota auto quick
>  119 log v2log auto
> -120 other auto
> -121 log auto
> -122 other auto
> -123 perms auto
> -124 pattern auto
> +120 other auto quick
> +121 log auto quick
> +122 other auto quick
> +123 perms auto quick
> +124 pattern auto quick
>  125 other auto
> -126 perms auto
> +126 perms auto quick
>  127 rw auto
> -128 perms auto
> -129 rw auto
> -130 pattern auto
> -131 perms auto
> +128 perms auto quick
> +129 rw auto quick
> +130 pattern auto quick
> +131 perms auto quick
>  132 pattern auto
>  133 rw auto
> -134 quota auto
> -135 metadata auto
> +134 quota auto quick
> +135 metadata auto quick
>  136 attr2
>  137 metadata log auto
>  138 metadata log auto
>  139 metadata log auto
>  140 metadata log auto
> -141 rw auto
> +141 rw auto quick
>  142 dmapi auto
>  143 dmapi auto
>  144 dmapi auto
> @@ -266,13 +266,13 @@
>  161 dmapi auto
>  162 dmapi auto
>  163 dmapi auto
> -164 rw pattern auto
> -165 rw pattern auto
> -166 rw metadata auto
> +164 rw pattern auto quick
> +165 rw pattern auto quick
> +166 rw metadata auto quick
>  167 rw metadata auto
>  168 dmapi auto
> -169 rw metadata auto
> -170 rw filestreams auto
> +169 rw metadata auto quick
> +170 rw filestreams auto quick
>  # the next three tests are not deterministic enough to get the
>  # "right" result on all platforms/configuration, so don't run
>  # them by default.
> @@ -283,27 +283,27 @@
>  175 dmapi auto
>  176 dmapi auto
>  177 rw other auto
> -178 mkfs other auto
> +178 mkfs other auto quick
>  179 metadata rw auto
>  180 metadata rw auto
> -181 log auto
> +181 log auto quick
>  182 metadata rw auto
> -183 rw other auto
> -184 metadata auto
> +183 rw other auto quick
> +184 metadata auto quick
>  185 dmapi auto
> -186 attr auto
> -187 attr auto
> +186 attr auto quick
> +187 attr auto quick
>  188 ci dir auto
> -189 mount auto
> -190 rw auto
> +189 mount auto quick
> +190 rw auto quick
>  191 nfs4acl auto
>  192 atime
> -193 metadata auto
> +193 metadata auto quick
>  194 rw auto
> -195 ioctl dump auto
> -196 quota auto
> -197 dir auto
> -199 mount auto
> -200 mount auto
> -201 metadata auto
> -202 repair auto
> +195 ioctl dump auto quick
> +196 quota auto quick
> +197 dir auto quick
> +199 mount auto quick
> +200 mount auto quick
> +201 metadata auto quick
> +202 repair auto quick
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
