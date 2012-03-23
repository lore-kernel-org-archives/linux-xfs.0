Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2NKkonN009473 for <xfs@oss.sgi.com>; Fri, 23 Mar 2012 15:46:50 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id ptk1CKnETnmYYJ0c for <xfs@oss.sgi.com>;
	Fri, 23 Mar 2012 13:46:48 -0700 (PDT)
Message-ID: <4F6CE137.3020405@sandeen.net>
Date: Fri, 23 Mar 2012 15:46:47 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_fsr XFS_IOC_SWAPEXT failed
References: <alpine.LRH.2.02.1203231552490.21859@mail.vlasiu.net>
	<4F6CD1DC.7010706@sandeen.net>
	<alpine.LRH.2.02.1203232159210.3056@mail.vlasiu.net>
	<4F6CD799.9090903@sandeen.net>
	<alpine.LRH.2.02.1203232220010.4760@mail.vlasiu.net>
In-Reply-To: <alpine.LRH.2.02.1203232220010.4760@mail.vlasiu.net>
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
To: Gabriel VLASIU <gabriel@vlasiu.net>
Cc: xfs@oss.sgi.com

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 3/23/12 3:22 PM, Gabriel VLASIU wrote:
> On Fri, 23 Mar 2012, Eric Sandeen wrote:
> 
>> It wouldn't be expected to.
> 
>> Please see also
> 
>> https://bugzilla.redhat.com/show_bug.cgi?id=671015
> 
>> and suggestions for tracing the error, so we know exactly which case this is.
> 
> # cat /sys/kernel/debug/tracing/trace
> # tracer: nop
> #
> # entries-in-buffer/entries-written: 2/2   #P:2
> #
> #                              _-----=> irqs-off
> #                             / _----=> need-resched
> #                            | / _---=> hardirq/softirq
> #                            || / _--=> preempt-depth
> #                            ||| /     delay
> #           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
> #              | |       |   ||||       |         |
>          xfs_fsr-3895  [000] .... 108290.726664: xfs_swap_extent_before: dev 7:0 ino 0x400dd2e4 (target), btree format, num_extents 1463, broot size 120, fork offset 104
>          xfs_fsr-3895  [000] .... 108290.726666: xfs_swap_extent_before: dev 7:0 ino 0x1c4917 (temp), extent format, num_extents 1, broot size 0, fork offset 104
> 
> Should I add the trace to the bugzilla?

Sure, that'd be great.

That's a little different case than the other trace provided in that bug.  TBH my mind is not fully engaged enough to see which case in xfs_swap_extents_check_format() is tripping this up.  I think it's this:

        /* Reciprocal target->temp btree format checks */
        if (ip->i_d.di_format == XFS_DINODE_FMT_BTREE) {
                if (XFS_IFORK_BOFF(tip) &&
                    ip->i_df.if_broot_bytes > XFS_IFORK_BOFF(tip))
                        return EINVAL;

Which means (I think) that the new temp inode doesn't have enough room before the attribute fork, compared to the original inode.

If you want to supply an xfs_metadump metadata image (in public or in private), we would have a reproducer.  It obfuscates most metadata by default.

- -Eric



> Thank you.
> 
> 
> Sincerely,
> Gabriel
> 
> 

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.17 (Darwin)
Comment: GPGTools - http://gpgtools.org
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPbOE2AAoJECCuFpLhPd7gCV0P/RuVduFuodbKJWDQ7Xks3ufO
MBWFS/d272KKsYEi45BmftKOw1wto3PvEtJOLL17mNOfJeGjJCruFSEizX6Px5nD
Nb5BCbmwpv+HVOaboNTTBIb2Pufp7HgOb2ReJPVxqdyJBxXtkhTCIWnGxG70xzYo
p5E6udZ9hGMzBFLLzBAaeC1Newa+1y52/i+qPdwudXYbwhSaCjsXf62Cpjm5j4iM
XEiR32coVGj2dS7BOuhPDmnrAMvRUqG4hMRLOZHC7JobVSaI3QU2gbGy+fIwZLHR
2DeQMFIMOuzE3rXTE+qjkTvGjv8DH0PAqJt2Q1bTgJzD2PGaZqvEAsCTSVF27wfv
PjZlmhLyuX6yFqMEST36csKpZ7h1ygzanipI17vD5Sj4z3aifAdXFOsuQNJCcCrl
+GDY6x4OQl2dLej6dKwTZG2V8IsUFSKxyC8lbIGJoGB0PRtPSV/KlxQzFOr+tyU9
/8pUYtmkKaDf6mLz6MK+8kjV+Zvyx33PV8I/NRaWXPTRlii8aWhJ34WuvTa/TT9K
y2R/DtorK5x52PNPFOHcGgHsj6x9KnvbD7fhOR3EC4OY7QzJHgVmnnR/nJC2TV1j
Y15EdFssIg1zZa1wajGVRpaBhhocK+lLtbdVUZS7yUQ7jSP077PgjJEaldMQkJtD
vOYfo2YVBN3V9/lCvyj9
=9+GV
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
