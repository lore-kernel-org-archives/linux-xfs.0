Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2OHBuwb069406 for <xfs@oss.sgi.com>; Sat, 24 Mar 2012 12:11:57 -0500
Received: from smtp.pobox.com (b-pb-sasl-quonix.pobox.com [208.72.237.35]) by
	cuda.sgi.com with ESMTP id SdB0nf0i9azZtuYA for
	<xfs@oss.sgi.com>; Sat, 24 Mar 2012 10:11:55 -0700 (PDT)
Date: Sat, 24 Mar 2012 17:11:50 +0000
From: Brian Candler <B.Candler@pobox.com>
Subject: Re: GNU 'tar', Schilling's 'tar', write-cache/barrier
Message-ID: <20120324171150.GA69366@nsrc.org>
References: <CAA8mOyDKrWg0QUEHxcD4ocXXD42nJu0TG+sXjC4j2RsigHTcmw@mail.gmail.com>
	<4F6624A3.5010206@hardwarefreak.com>
	<20331.39194.377610.888636@tree.ty.sabi.co.UK>
	<201203232348.09158.Martin@lichtvoll.de>
	<20333.8944.573177.821944@tree.ty.sabi.co.UK>
	<20333.62951.784434.92213@tree.ty.sabi.co.UK>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20333.62951.784434.92213@tree.ty.sabi.co.UK>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Peter Grandi <pg_xf2@xf2.for.sabi.co.UK>
Cc: Linux fs XFS <xfs@oss.sgi.com>

On Sat, Mar 24, 2012 at 04:27:19PM +0000, Peter Grandi wrote:
> --------------------------------------------------------------
> #  (cd /tmp/ext4; rm -rf linux-2.6.32; sync; time star -no-fsync -x -f /t=
mp/linux-2.6.32.tar; egrep 'Dirty|Writeback' /proc/meminfo; time sync)
> star: 37343 blocks + 0 bytes (total of 382392320 bytes =3D 373430.00k).
> =

> real    0m1.204s
> user    0m0.139s
> sys     0m1.270s
> Dirty:          419456 kB
> Writeback:           0 kB
> =

> real    0m5.012s
> user    0m0.000s
> sys     0m0.458s
> --------------------------------------------------------------
> #  (cd /tmp/ext4; rm -rf linux-2.6.32; sync; time star -x -f /tmp/linux-2=
.6.32.tar; egrep 'Dirty|Writeback' /proc/meminfo; time sync)
> star: 37343 blocks + 0 bytes (total of 382392320 bytes =3D 373430.00k).
> =

> real    23m29.346s
> user    0m0.327s
> sys     0m2.280s
> Dirty:             108 kB
> Writeback:           0 kB
> =

> real    0m0.236s
> user    0m0.000s
> sys     0m0.199s

But as a user, what guarantees do I *want* from tar?

I think the only meaningful guarantee I might want is: "if the tar returns
successfully, I want to know that all the files are persisted to disk".  And
of course that's what your final "sync" does, although with the unfortunate
side-effect of syncing all other dirty blocks in the system too.

Calling fsync() after every single file is unpacked does also achieve the
desired guarantee, but at a very high cost.  This is partly because you have
to wait for each fsync() to return [although I guess you could spawn threads
to do them] but also because the disk can't aggregate lots of small writes
into one larger write, even when the filesystem has carefully allocated them
in adjacent blocks.

I think what's needed is a group fsync which says "please ensure this set of
files is all persisted to disk", which is done at the end, or after every N
files.  If such an API exists I don't know of it.

On the flip side, does fsync()ing each individual file buy you anything over
and above the desired guarantee?  Possibly - in theory you could safely
restart an aborted untar even through a system crash.  You would have to be
aware that the last file which was unpacked may only have been partially
written to disk, so you'd have to restart by overwriting the last item in
the archive which already exists on disk.  Maybe star has this feature, I
don't know.  And unlike zip, I don't think tarfiles are indexed, so you'd
still have to read it from the beginning.

If the above benchmark is typical, it suggests that fsyncing after every
file is 4 times slower than untar followed by sync.  So I reckon you would
be better off using the fast/unsafe version, and simply restarting it from
the beginning if the system crashed while you were running it.  That's
unless you expect the system to crash 4 or more times while you untar this
single file.

Just my 2=A2, as a user and definitely not a filesystem expert.

Regards,

Brian.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
