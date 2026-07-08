Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 993FA330324;
	Wed,  8 Jul 2026 00:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783470867; cv=none; b=E6Uw/JRHxU6qsChOZFgZ0bOirVMTy7RwW9EwByEd0w3c2pCeLTJ56d7+k/ZDbGiSnCj6+YjXOL7Qs3Ze0JE/XwBfCxs9mnLtt5V93a/8ZvX7GGwqFmFg7uyLnLbbckbaW32qZpM703x56BCL4r7/LKrfWBKaalB3MEfRzggMt28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783470867; c=relaxed/simple;
	bh=tatnELksLVyM9K5DSmIls9fgV24I9wSPWY+00vyRSj0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TWafHDYUjhA5r/BhvKKkRCarOyqLnzMQg1w3E7Aahxigq4lRlygBmQzLPbURxY0K9jc6igCRAh78ORtyN0JWLBwjYaHjgDXnmUENXy/MQZpD+OFw2tn0kZG+/bC2d22VsvdEvKbczntMBNle4NBxS9hrEbcS8tsfUjPGjcFVKA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=EmAM0NpZ; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="EmAM0NpZ"
Received: by linux.microsoft.com (Postfix, from userid 1216)
	id 0D06C20B7166; Tue,  7 Jul 2026 17:34:12 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0D06C20B7166
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1783470852;
	bh=69JY2sPL0NaFnoG7elEbCqqEQmF4M3/8ID24gUwVqcw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EmAM0NpZ5ZRykFK42efARueYCdQCViGbqs3+bMw9pa1YSAUiS53z0ycybr56XMgop
	 1P/EGbESR1p1OkYIiVTxJxNRViql84x5Edrhna4k+MJ2ozmcF9RJVD6O/osubHK4yv
	 qhsw7moJMPMjov62Za2UTntNHZiC3z8pMLtMjogE=
Date: Tue, 7 Jul 2026 20:34:12 -0400
From: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
To: Sasha Levin <sashal@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, Amir Goldstein <amir73il@gmail.com>,
	Fedor Pchelkin <pchelkin@ispras.ru>, stable@vger.kernel.org,
	xfs-stable@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
	Catherine Hoang <catherine.hoang@oracle.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	lvc-project@linuxtesting.org, linux-xfs@vger.kernel.org,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Theodore Ts'o <tytso@mit.edu>,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH 6.6 0/4] fix kernel crash for xfs/235 test
Message-ID: <ak2bBIGLumgLD4nd@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20260701163310.GB6517@frogsfrogsfrogs>
 <stable-reply-xfs-235-fstests-66y-20260702213502@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="KFt0mAB3puHSe9pa"
Content-Disposition: inline
In-Reply-To: <stable-reply-xfs-235-fstests-66y-20260702213502@kernel.org>


--KFt0mAB3puHSe9pa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 03, 2026 at 12:06:56AM -0400, Sasha Levin wrote:
> On Wed, Jul 01, 2026 at 09:33:10AM -0700, Darrick J. Wong wrote:
> > On Tue, Jun 30, 2026 at 07:39:32PM -0400, Hamza Mahfooz wrote:
> > > Any idea on potential paths forward for getting this series in
> > > particular into 6.6.y?
> >
> > Run fstests, and if there are no new regressions, ask sasha/greg to
> > queue it.
> 
> Thanks Darrick.
> 
> Hamza, could you apply the four patches on top of the current 6.6.y
> tree, run fstests, and report the results here? The series was written
> against 6.6.84-rc2 about 15 months ago, so a fresh run against today's
> 6.6.y would both satisfy Darrick's condition and confirm the series
> still behaves on the current tree.

I ran fstests both before and after applying the series with "-g auto"
as Amir suggested and the only meaningful difference between the two is
that all of the tests after xfs/234 refuse to run on the unpatched
kernel (presumably because of the kernel panic). I have also attached
both runs if you're interested in having a look for yourself.

> 
> Once a clean fstests run is reported I'll queue the series up for 6.6.
> 
> -- 
> Thanks,
> Sasha

--KFt0mAB3puHSe9pa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="fstests-auto-baseline.log"
Content-Transfer-Encoding: quoted-printable

FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64 hamza-azl3-fstests 6.6.144.1-1.azl3 #1 SMP PR=
EEMPT_DYNAMIC Mon Jul  6 10:06:46 UTC 2026
MKFS_OPTIONS  -- -f /dev/sdb
MOUNT_OPTIONS -- /dev/sdb /mnt/scratch

generic/001         3s
generic/002         1s
generic/003         12s
generic/004         1s
generic/005         0s
generic/006         1s
generic/007         1s
generic/008         1s
generic/009         2s
generic/010        [not run] /home/azureuser/xfstests-dev/src/dbtest not bu=
ilt
generic/011         1s
generic/012         1s
generic/013         5s
generic/014         3s
generic/015         3s
generic/016         1s
generic/017         118s
generic/018         3s
generic/020         3s
generic/021         1s
generic/022         1s
generic/023         1s
generic/024         1s
generic/025         1s
generic/026         3s
generic/027         34s
generic/028         6s
generic/029         1s
generic/030         3s
generic/031         1s
generic/032         7s
generic/033         1s
generic/034         2s
generic/035         1s
generic/036        [not run] /home/azureuser/xfstests-dev/src/aio-dio-regre=
ss/aio-dio-fcntl-race not built
generic/037         6s
generic/038         33s
generic/039         2s
generic/040         7s
generic/041         8s
generic/042         14s
generic/043         14s
generic/044         17s
generic/045         17s
generic/046         17s
generic/047         28s
generic/048         82s
generic/049         12s
generic/050         3s
generic/051         93s
generic/052         3s
generic/053         2s
generic/054         69s
generic/055         47s
generic/056         4s
generic/057         4s
generic/058         2s
generic/059         3s
generic/060         2s
generic/061         1s
generic/062        - output mismatch (see /home/azureuser/xfstests-dev/resu=
lts//generic/062.out.bad)
    --- tests/generic/062.out	2026-07-07 12:16:09.188601915 +0000
    +++ /home/azureuser/xfstests-dev/results//generic/062.out.bad	2026-07-0=
7 12:33:50.038487667 +0000
    @@ -649,6 +649,7 @@
     SCRATCH_MNT/lnk
     SCRATCH_MNT/reg
     *** restore everything
    +Warning: option --restore=3Dfile is unsafe without option -P (--physic=
al) as it traverses symbolic links in pathnames
     *** compare before and after backups
    =20
     *** unmount
    ...
    (Run 'diff -u /home/azureuser/xfstests-dev/tests/generic/062.out /home/=
azureuser/xfstests-dev/results//generic/062.out.bad'  to see the entire dif=
f)
generic/063         1s
generic/064         2s
generic/065         2s
generic/066         2s
generic/067         2s
generic/068         46s
generic/069         4s
generic/070         3s
generic/071         1s
generic/072         12s
generic/073         2s
generic/074         133s
generic/075         33s
generic/076         3s
generic/077         15s
generic/078         2s
generic/079         1s
generic/080         3s
generic/081         3s
generic/082         2s
generic/083         4s
generic/084         7s
generic/085         18s
generic/086         1s
generic/087         1s
generic/088         1s
generic/089         4s
generic/090         2s
generic/091         47s
generic/092         0s
generic/093         1s
generic/094         51s
generic/095        [not run] kernel does not support asynchronous I/O
generic/096         2s
generic/097         1s
generic/098         1s
generic/099         2s
generic/100         14s
generic/101         1s
generic/102         3s
generic/103         2s
generic/104         2s
generic/105         1s
generic/106         2s
generic/107         2s
generic/108         3s
generic/109         2s
generic/110         2s
generic/111         0s
generic/112        [not run] kernel does not support asynchronous I/O
generic/113        [not run] kernel does not support asynchronous I/O
generic/114        [not run] /home/azureuser/xfstests-dev/src/aio-dio-regre=
ss/aio-dio-eof-race not built
generic/115         1s
generic/116         1s
generic/117         5s
generic/118         1s
generic/119         2s
generic/120         16s
generic/121         1s
generic/122         2s
generic/123         1s
generic/124         2s
generic/125         62s
generic/126         1s
generic/127         221s
generic/128         1s
generic/129         7s
generic/130         12s
generic/131         2s
generic/132         12s
generic/133         102s
generic/134         2s
generic/135         1s
generic/136         1s
generic/137         15s
generic/138         1s
generic/139         2s
generic/140         1s
generic/141         1s
generic/142         3s
generic/143         50s
generic/144         1s
generic/145         1s
generic/146         2s
generic/147         1s
generic/148         1s
generic/149         1s
generic/150         1s
generic/151         1s
generic/152         2s
generic/153         1s
generic/154         2s
generic/155         6s
generic/156         3s
generic/157         2s
generic/158         3s
generic/159         1s
generic/160         1s
generic/161         3s
generic/162         22s
generic/163         34s
generic/164         7s
generic/165         20s
generic/166         44s
generic/167         8s
generic/168         38s
generic/169         2s
generic/170         80s
generic/171         3s
generic/172         8s
generic/173         3s
generic/174         4s
generic/175         108s
generic/176         230s
generic/177         2s
generic/178         2s
generic/179         2s
generic/180         1s
generic/181         1s
generic/182         4s
generic/183         3s
generic/184         1s
generic/185         2s
generic/186         24s
generic/187         33s
generic/188         5s
generic/189         3s
generic/190         4s
generic/191         7s
generic/192         7s
generic/193         2s
generic/194         5s
generic/195         4s
generic/196         3s
generic/197         3s
generic/198        [not run] /home/azureuser/xfstests-dev/src/aio-dio-regre=
ss/aiodio_sparse2 not built
generic/199         4s
generic/200         4s
generic/201         2s
generic/202         3s
generic/203         3s
generic/204         16s
generic/205         2s
generic/206         3s
generic/207        [not run] /home/azureuser/xfstests-dev/src/aio-dio-regre=
ss/aio-dio-extend-stat not built
generic/208        [not run] /home/azureuser/xfstests-dev/src/aio-dio-regre=
ss/aio-dio-invalidate-failure not built
generic/209        [not run] /home/azureuser/xfstests-dev/src/aio-dio-regre=
ss/aio-dio-invalidate-readahead not built
generic/210        [not run] /home/azureuser/xfstests-dev/src/aio-dio-regre=
ss/aio-dio-subblock-eof-read not built
generic/211         5s
generic/212        [not run] /home/azureuser/xfstests-dev/src/aio-dio-regre=
ss/aio-io-setup-with-nonwritable-context-pointer not built
generic/213         1s
generic/214         1s
generic/215         3s
generic/216         2s
generic/217         2s
generic/218         3s
generic/219         2s
generic/220         3s
generic/221         2s
generic/222         2s
generic/223         9s
generic/224         18s
generic/225         86s
generic/226         15s
generic/227         6s
generic/228         1s
generic/229         8s
generic/230         15s
generic/231         92s
generic/232         23s
generic/233         19s
generic/234         16s
generic/235         2s
generic/236         2s
generic/237         1s
generic/238         8s
generic/239        [not run] /home/azureuser/xfstests-dev/src/aio-dio-regre=
ss/aio-dio-hole-filling-race not built
generic/240        [not run] /home/azureuser/xfstests-dev/src/aio-dio-regre=
ss/aiodio_sparse2 not built
generic/241        [not run] dbench not found
generic/242         32s
generic/243         34s
generic/244         5s
generic/245         1s
generic/246         1s
generic/247         11s
generic/248         1s
generic/249         1s
generic/250         3s
generic/251         33s
generic/252        [not run] /home/azureuser/xfstests-dev/src/aio-dio-regre=
ss/aiocp not built
generic/253         2s
generic/254         2s
generic/255         2s
generic/256         32s
generic/257         1s
generic/258         1s
generic/259         2s
generic/260         27s
generic/261         6s
generic/262         3s
generic/263         21s
generic/264         2s
generic/265         4s
generic/266         3s
generic/267         4s
generic/268         4s
generic/269         28s
generic/270         60s
generic/271         3s
generic/272         4s
generic/273         7s
generic/274         16s
generic/275         13s
generic/276         4s
generic/277         3s
generic/278         4s
generic/279         4s
generic/280         2s
generic/281         4s
generic/282         4s
generic/283         4s
generic/284         3s
generic/285         1s
generic/286         1s
generic/287         3s
generic/288         1s
generic/289         3s
generic/290         3s
generic/291         3s
generic/292         4s
generic/293         4s
generic/294         1s
generic/295         4s
generic/296         3s
generic/297         53s
generic/298         52s
generic/299        [not run] kernel does not support asynchronous I/O
generic/300        [not run] kernel does not support asynchronous I/O
generic/301         4s
generic/302         38s
generic/303         1s
generic/304         1s
generic/305         3s
generic/306         2s
generic/307         3s
generic/308         1s
generic/309         2s
generic/310         64s
generic/311         112s
generic/312         2s
generic/313         5s
generic/314         1s
generic/315         1s
generic/316         1s
generic/317         1s
generic/318         2s
generic/319         1s
generic/320         27s
generic/321         4s
generic/322         2s
generic/323        [not run] /home/azureuser/xfstests-dev/src/aio-dio-regre=
ss/aio-last-ref-held-by-io not built
generic/324         13s
generic/325         2s
generic/326         3s
generic/327         3s
generic/328         3s
generic/329        [not run] /home/azureuser/xfstests-dev/src/aio-dio-regre=
ss/aiocp not built
generic/330        [not run] /home/azureuser/xfstests-dev/src/aio-dio-regre=
ss/aiocp not built
generic/331        [not run] /home/azureuser/xfstests-dev/src/aio-dio-regre=
ss/aiocp not built
generic/332        [not run] /home/azureuser/xfstests-dev/src/aio-dio-regre=
ss/aiocp not built
generic/333         28s
generic/334         10s
generic/335         1s
generic/336         2s
generic/337         2s
generic/338         1s
generic/339         4s
generic/340         2s
generic/341         2s
generic/342         2s
generic/343         2s
generic/344         3s
generic/345         3s
generic/346         2s
generic/347         69s
generic/348         2s
generic/352         14s
generic/353         3s
generic/354         3s
generic/355         1s
generic/356         3s
generic/357         3s
generic/358         7s
generic/359         3s
generic/360         1s
generic/361         4s
generic/362         1s
generic/363        [failed, exit status 1]- output mismatch (see /home/azur=
euser/xfstests-dev/results//generic/363.out.bad)
    --- tests/generic/363.out	2026-07-07 12:16:09.204601825 +0000
    +++ /home/azureuser/xfstests-dev/results//generic/363.out.bad	2026-07-0=
7 13:26:24.375662184 +0000
    @@ -1,2 +1,298 @@
     QA output created by 363
     fsx -q -S 0 -e 1 -N 100000
    +READ BAD DATA: offset =3D 0x39bcf, size =3D 0x6431, fname =3D /mnt/tes=
t/junk
    +OFFSET      GOOD    BAD     RANGE
    +0x3a91b     0x0000  0x6e00  0x0
    +operation# (mod 256) for the bad data unknown, check HOLE and EXTEND o=
ps
    +0x3a91d     0x0000  0x5e00  0x1
    ...
    (Run 'diff -u /home/azureuser/xfstests-dev/tests/generic/363.out /home/=
azureuser/xfstests-dev/results//generic/363.out.bad'  to see the entire dif=
f)
generic/364         11s
generic/365        - output mismatch (see /home/azureuser/xfstests-dev/resu=
lts//generic/365.out.bad)
    --- tests/generic/365.out	2026-07-07 12:16:09.204601825 +0000
    +++ /home/azureuser/xfstests-dev/results//generic/365.out.bad	2026-07-0=
7 13:26:37.763584661 +0000
    @@ -2,14 +2,12 @@
     test incorrect setting of high key
     	XXXX: XXXX:XXXX [XXXX..XXXX]: USED XXXX
     test missing free space extent
    -	XXXX: XXXX:XXXX [XXXX..XXXX]: FREE XXXX
     test whatever came before freesp
     	XXXX: XXXX:XXXX [XXXX..XXXX]: USED XXXX
     test whatever came after freesp
    ...
    (Run 'diff -u /home/azureuser/xfstests-dev/tests/generic/365.out /home/=
azureuser/xfstests-dev/results//generic/365.out.bad'  to see the entire dif=
f)

HINT: You _MAY_ be missing kernel fix:
      68415b349f3f xfs: Fix the owner setting issue for rmap query in xfs f=
smap

HINT: You _MAY_ be missing kernel fix:
      ca6448aed4f1 xfs: Fix missing interval for missing_owner in xfs fsmap

generic/366        [not run] kernel does not support asynchronous I/O
generic/368        [not run] filesystem doesn't support -o inlinecrypt
generic/369        [not run] filesystem doesn't support -o inlinecrypt
generic/370         6s
generic/371         20s
generic/372         4s
generic/373         2s
generic/374         2s
generic/375         2s
generic/376         1s
generic/377         2s
generic/378         1s
generic/379         4s
generic/380         4s
generic/381         1s
generic/382         6s
generic/383         1s
generic/384         2s
generic/385         4s
generic/386         1s
generic/387         29s
generic/388         410s
generic/389         1s
generic/390         2s
generic/391         3s
generic/392         7s
generic/393         2s
generic/394         1s
generic/395        [not run] No encryption support for xfs
generic/396        [not run] No encryption support for xfs
generic/397        [not run] No encryption support for xfs
generic/398        [not run] No encryption support for xfs
generic/399        [not run] No encryption support for xfs
generic/400         2s
generic/401         2s
generic/402         1s
generic/403         2s
generic/404         15s
generic/405         62s
generic/406         3s
generic/407         2s
generic/408         2s
generic/409         10s
generic/410         18s
generic/411         2s
generic/412         1s
generic/413        [not run] /dev/sdb xfs does not support -o dax
generic/414         2s
generic/415         96s
generic/416         63s
generic/417         16s
generic/418         21s
generic/419        [not run] No encryption support for xfs
generic/420         1s
generic/421        [not run] No encryption support for xfs
generic/422         2s
generic/423         1s
generic/424         1s
generic/425         2s
generic/426         2s
generic/427        [not run] /home/azureuser/xfstests-dev/src/aio-dio-regre=
ss/aio-dio-eof-race not built
generic/428         1s
generic/429        [not run] No encryption support for xfs
generic/430         1s
generic/431         1s
generic/432         0s
generic/433         1s
generic/434         1s
generic/435        [not run] No encryption support for xfs
generic/436         1s
generic/437         1s
generic/438         587s
generic/439         2s
generic/440        [not run] No encryption support for xfs
generic/441         1s
generic/443         1s
generic/444         1s
generic/445         1s
generic/446         9s
generic/447         126s
generic/448         1s
generic/449         30s
generic/450         1s
generic/451        [not run] /home/azureuser/xfstests-dev/src/aio-dio-regre=
ss/aio-dio-cycle-write not built
generic/452         1s
generic/453         2s
generic/454         2s
generic/455        [not run] This test requires a valid $LOGWRITES_DEV
generic/456         2s
generic/457        [not run] This test requires a valid $LOGWRITES_DEV
generic/458         2s
generic/459        [not run] thin_check utility required, skipped this test
generic/460         7s
generic/461         22s
generic/462        [not run] /dev/sdb xfs does not support -o dax
generic/463        [not run] /home/azureuser/xfstests-dev/src/aio-dio-regre=
ss/aio-dio-cow-race not built
generic/464         71s
generic/465        [not run] /home/azureuser/xfstests-dev/src/aio-dio-regre=
ss/aio-dio-append-write-read-race not built
generic/466         13s
generic/467         2s
generic/468         4s
generic/469         1s
generic/470        [not run] This test requires a valid $LOGWRITES_DEV
generic/471         1s
generic/472         2s
generic/474         2s
generic/475         572s
generic/476         43s
generic/477         3s
generic/478         11s
generic/479         4s
generic/480         1s
generic/481         2s
generic/482        [not run] This test requires a valid $LOGWRITES_DEV
generic/483         4s
generic/484         2s
generic/485         1s
generic/486         1s
generic/487        [not run] This test requires a valid $SCRATCH_LOGDEV
generic/488         1s
generic/489         2s
generic/490         1s
generic/491         1s
generic/492         2s
generic/493         3s
generic/494         2s
generic/495         2s
generic/496         3s
generic/497         2s
generic/498         2s
generic/499         2s
generic/500         27s
generic/501         80s
generic/502         2s
generic/503         6s
generic/504         1s
generic/505         2s
generic/506         3s
generic/507         6s
generic/508         3s
generic/509         2s
generic/510         2s
generic/511         2s
generic/512         2s
generic/513         3s
generic/514         3s
generic/515         4s
generic/516         2s
generic/517         6s
generic/518         5s
generic/519         4s
generic/520         31s
generic/523         1s
generic/524         6s
generic/525         1s
generic/526         2s
generic/527         2s
generic/528         2s
generic/529         1s
generic/530         11s
generic/531         7s
generic/532         2s
generic/533         1s
generic/534         1s
generic/535         3s
generic/536         2s
generic/537         2s
generic/538        [not run] /home/azureuser/xfstests-dev/src/aio-dio-regre=
ss/aio-dio-write-verify not built
generic/539         1s
generic/540         4s
generic/541         3s
generic/542         4s
generic/543         4s
generic/544         4s
generic/545         2s
generic/546         5s
generic/547         6s
generic/548        [not run] No encryption support for xfs
generic/549        [not run] No encryption support for xfs
generic/550        [not run] No encryption support for xfs
generic/551        [not run] /home/azureuser/xfstests-dev/src/aio-dio-regre=
ss/aio-dio-write-verify not built
generic/552         4s
generic/553         2s
generic/554         4s
generic/555         1s
generic/556        [not run] xfs does not support casefold feature
generic/557         1s
generic/558         88s
generic/559        [not run] duperemove utility required, skipped this test
generic/560        [not run] duperemove utility required, skipped this test
generic/561        [not run] duperemove utility required, skipped this test
generic/562         62s
generic/563         3s
generic/564         1s
generic/565        [not run] xfs does not support cross-device copy_file_ra=
nge
generic/566         2s
generic/567         2s
generic/568         1s
generic/569         2s
generic/570        [not run] userspace hibernation to swap is enabled
generic/571         7s
generic/572        [not run] fsverity utility required, skipped this test
generic/573        [not run] fsverity utility required, skipped this test
generic/574        [not run] fsverity utility required, skipped this test
generic/575        [not run] fsverity utility required, skipped this test
generic/576        [not run] fsverity utility required, skipped this test
generic/577        [not run] fsverity utility required, skipped this test
generic/578         1s
generic/579        [not run] fsverity utility required, skipped this test
generic/580        [not run] No encryption support for xfs
generic/581        [not run] No encryption support for xfs
generic/582        [not run] No encryption support for xfs
generic/583        [not run] No encryption support for xfs
generic/584        [not run] No encryption support for xfs
generic/585         1s
generic/586        [not run] /home/azureuser/xfstests-dev/src/aio-dio-regre=
ss/aio-dio-append-write-fallocate-race not built
generic/587         2s
generic/588         3s
generic/589         13s
generic/590         73s
generic/591         2s
generic/592        [not run] No encryption support for xfs
generic/593        [not run] No encryption support for xfs
generic/594         2s
generic/595        [not run] No encryption support for xfs
generic/596        [not run] accton utility required, skipped this test
generic/597         2s
generic/598         2s
generic/599         2s
generic/600         5s
generic/601         5s
generic/602        [not run] No encryption support for xfs
generic/603         51s
generic/604         3s
generic/605        [not run] /dev/sdb xfs does not support -o dax=3Dalways
generic/606        [not run] /dev/sdb xfs does not support -o dax=3Dalways
generic/607         3s
generic/608        [not run] /dev/sdb xfs does not support -o dax=3Dalways
generic/609         2s
generic/610         3s
generic/611         1s
generic/612         2s
generic/613        [not run] No encryption support for xfs
generic/614         2s
generic/615         20s
generic/616        [not run] kernel does not support IO_URING
generic/617        [not run] kernel does not support IO_URING
generic/618         1s
generic/619         35s
generic/620         15s
generic/621        [not run] No encryption support for xfs
generic/622         28s
generic/623         3s
generic/624        [not run] fsverity utility required, skipped this test
generic/625        [not run] fsverity utility required, skipped this test
generic/626         2s
generic/627        [not run] kernel does not support asynchronous I/O
generic/628         3s
generic/629         3s
generic/630         28s
generic/631         31s
generic/632         2s
generic/633         1s
generic/634         2s
generic/635         2s
generic/636         4s
generic/637         4s
generic/638         2s
generic/639         3s
generic/640         3s
generic/641         5s
generic/642         259s
generic/643         3s
generic/644         1s
generic/645        [failed, exit status 1]- output mismatch (see /home/azur=
euser/xfstests-dev/results//generic/645.out.bad)
    --- tests/generic/645.out	2026-07-07 12:16:09.216601757 +0000
    +++ /home/azureuser/xfstests-dev/results//generic/645.out.bad	2026-07-0=
7 14:25:40.686549507 +0000
    @@ -1,2 +1,4 @@
     QA output created by 645
     Silence is golden
    +idmapped-mounts.c: 6671: nested_userns - Success - failure: sys_mount_=
setattr
    +vfstest.c: 2418: run_test - Success - failure: test that nested user n=
amespaces behave correctly when attached to idmapped mounts
    ...
    (Run 'diff -u /home/azureuser/xfstests-dev/tests/generic/645.out /home/=
azureuser/xfstests-dev/results//generic/645.out.bad'  to see the entire dif=
f)

This test wants kernel fix:
      dacfd001eaf2 fs/mnt_idmapping.c: Return -EINVAL when no map is written

generic/646         3s
generic/647         1s
generic/648         218s
generic/649         3s
generic/650         46s
generic/651         2s
generic/652         3s
generic/653         2s
generic/654         3s
generic/655         6s
generic/656         2s
generic/657         3s
generic/658         3s
generic/659         3s
generic/660         2s
generic/661         4s
generic/662         4s
generic/663         3s
generic/664         3s
generic/665         3s
generic/666         4s
generic/667         4s
generic/668         3s
generic/669         4s
generic/670         7s
generic/671         19s
generic/672         39s
generic/673         5s
generic/674         4s
generic/675         3s
generic/676         2s
generic/677         7s
generic/678        [not run] kernel does not support IO_URING
generic/679        [not run] not suitable for this filesystem type: xfs
generic/680         1s
generic/681         3s
generic/682         2s
generic/683         2s
generic/684         1s
generic/685         2s
generic/686         1s
generic/687         1s
generic/688         1s
generic/689         1s
generic/690         2s
generic/691         24s
generic/692        [not run] fsverity utility required, skipped this test
generic/693        [not run] No encryption support for xfs
generic/694         1s
generic/695         1s
generic/696         2s
generic/697         1s
generic/698         2s
generic/699         1s
generic/700        [not run] Require selinux to be enabled
generic/701         1s
generic/702         2s
generic/703        [not run] kernel does not support IO_URING
generic/704         2s
generic/705         17s
generic/706         1s
generic/707         63s
generic/708         0s
generic/709        [not run] xfs_io exchangerange  support is missing
generic/710        [not run] xfs_io exchangerange  support is missing
generic/711         3s
generic/712        [not run] xfs_io exchangerange  support is missing
generic/713        [not run] xfs_io exchangerange  -s 64k -l 64k support is=
 missing
generic/714        [not run] xfs_io exchangerange  support is missing
generic/715        [not run] xfs_io exchangerange  -s 64k -l 64k support is=
 missing
generic/716        [not run] xfs_io exchangerange  support is missing
generic/717        [not run] xfs_io exchangerange  support is missing
generic/718        [not run] xfs_io exchangerange  support is missing
generic/719        [not run] xfs_io exchangerange  support is missing
generic/720        [not run] xfs_io exchangerange  support is missing
generic/721        [not run] xfs_io startupdate  support is missing
generic/722        [not run] xfs_io exchangerange  support is missing
generic/723        [not run] xfs_io exchangerange  support is missing
generic/724        [not run] xfs_io exchangerange  support is missing
generic/725        [not run] xfs_io exchangerange  support is missing
generic/726        [not run] xfs_io exchangerange  support is missing
generic/727        [not run] xfs_io exchangerange  support is missing
generic/728         5s
generic/729         1s
generic/730         3s
generic/731         2s
generic/732         2s
generic/733         9s
generic/734         1s
generic/735         1s
generic/736         1s
generic/737        [not run] /home/azureuser/xfstests-dev/src/aio-dio-regre=
ss/aio-dio-write-verify not built
generic/738         19s
generic/739        [not run] No encryption support for xfs
generic/740         23s
generic/741         2s
generic/742         22s
generic/743        [not run] xfs_io madvise doesn't support -R
generic/744        [not run] xfs does not support duplicate fsid
generic/745         11s
generic/746         58s
generic/747         110s
generic/748         51s
generic/749         6s
generic/750         95s
generic/751         135s
generic/752        [not run] xfs_io exchangerange  support is missing
generic/753        _check_xfs_filesystem: filesystem on /dev/sdb is inconsi=
stent (r)
(see /home/azureuser/xfstests-dev/results//generic/753.full for details)

generic/754        _check_xfs_filesystem: filesystem on /dev/sdb is inconsi=
stent (r)
(see /home/azureuser/xfstests-dev/results//generic/754.full for details)


HINT: You _MAY_ be missing kernel fix:
      38de567906d95 xfs: allow symlinks with short remote targets

HINT: You _MAY_ be missing xfsprogs fix:
      XXXXXXXXXXXXX xfs_repair: small remote symlinks are ok

generic/755         3s
generic/756        [not run] statx does not support STATX_MNT_ID_UNIQUE on =
this kernel
generic/757        [not run] aio-dio utilities required
generic/758         2s
generic/759         29s
generic/760         28s
generic/761         28s
generic/762         2s
generic/763         1s
generic/764         1s
generic/765        [not run] write atomic not supported by this block device
generic/766        [not run] This test requires a valid $SCRATCH_LOGDEV
generic/767        [not run] write atomic not supported by this block device
generic/768        [not run] xfs_io pwrite doesn't support -A
generic/769        [not run] xfs_io pwrite doesn't support -A
generic/770        [not run] xfs_io pwrite doesn't support -A
generic/771         2s
generic/772        [not run] /home/azureuser/xfstests-dev/src/file_attr not=
 built
generic/773        [not run] write atomic not supported by this block device
generic/774        [not run] kernel does not support asynchronous I/O
generic/775        [not run] xfs_io pwrite doesn't support -A
generic/776        [not run] write atomic not supported by this block device
generic/777        [not run] xfs does not support connectable file handles
generic/778        [not run] xfs_io pwrite doesn't support -A
generic/779         1s
generic/781        [not run] This test requires zoned loopback device suppo=
rt
generic/782         2s
generic/783        [not run] xfs does not support casefold feature
generic/784         2s
generic/785         2s
generic/786        [not run] Require fcntl setdeleg support
generic/787        [not run] Require fcntl setdeleg support
generic/788        [not run] fsverity utility required, skipped this test
generic/789         1s
generic/790         2s
generic/791        [not run] xfs_io healthmon -p support is missing
generic/792         2s
generic/793        [not run] this test requires a zoned block device
generic/794        - output mismatch (see /home/azureuser/xfstests-dev/resu=
lts//generic/794.out.bad)
    --- tests/generic/794.out	2026-07-07 12:16:09.224601711 +0000
    +++ /home/azureuser/xfstests-dev/results//generic/794.out.bad	2026-07-0=
7 14:48:18.670439602 +0000
    @@ -1,4 +1,8 @@
     QA output created by 794
     append_write
    +FAIL: non-zero data in gap [4080,4096) after shutdown+remount
    +000000 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  >ZZZZZZZZZZZZZ=
ZZZ<
    +*
    +001000
     truncate_up
    ...
    (Run 'diff -u /home/azureuser/xfstests-dev/tests/generic/794.out /home/=
azureuser/xfstests-dev/results//generic/794.out.bad'  to see the entire dif=
f)
xfs/001             6s
xfs/002            [not run] v4 file systems not supported
xfs/003             1s
xfs/004             1s
xfs/005             2s
xfs/006             3s
xfs/007             3s
xfs/008             1s
xfs/009             2s
xfs/010             8s
xfs/011             19s
xfs/012             1s
xfs/013             90s
xfs/014             8s
xfs/015             5s
xfs/016            [not run] Cannot run this test using log MKFS_OPTIONS sp=
ecified
xfs/017             6s
xfs/018            [not run] XFS error injection requires CONFIG_XFS_DEBUG
xfs/019             1s
xfs/020             1s
xfs/021             2s
xfs/026            [not run] xfsdump not found
xfs/027            [not run] xfsdump not found
xfs/028            [not run] xfsdump not found
xfs/029             1s
xfs/030             9s
xfs/031             8s
xfs/032             24s
xfs/033             5s
xfs/034             2s
xfs/035            [not run] xfsdump not found
xfs/040            [not run] Can't run libxfs-diff without KWORKAREA set
xfs/041             18s
xfs/042             24s
xfs/044            [not run] This test requires a valid $SCRATCH_LOGDEV
xfs/045             3s
xfs/046            [not run] xfsdump not found
xfs/047            [not run] xfsdump not found
xfs/048             1s
xfs/049             10s
xfs/050             10s
xfs/051            [not run] sysfs attribute 'debug/log_recovery_delay' is =
not supported
xfs/052             1s
xfs/053             2s
xfs/054             1s
xfs/056            [not run] xfsdump not found
xfs/057            [not run] XFS error injection requires CONFIG_XFS_DEBUG
xfs/058             2s
xfs/059            [not run] xfsdump not found
xfs/060            [not run] xfsdump not found
xfs/061            [not run] xfsdump not found
xfs/062             6s
xfs/063            [not run] xfsdump not found
xfs/064            [not run] xfsdump not found
xfs/065            [not run] xfsdump not found
xfs/066            [not run] xfsdump not found
xfs/067             2s
xfs/068            [not run] xfsdump not found
xfs/069             2s
xfs/070             3s
xfs/071             1s
xfs/072             2s
xfs/073             27s
xfs/074             2s
xfs/075             1s
xfs/076             10s
xfs/077             17s
xfs/078             6s
xfs/079             39s
xfs/080             4s
xfs/081             6s
xfs/082             1s
xfs/084             59s
xfs/090            [not run] External volumes not in use, skipped this test
xfs/092             1s
xfs/094            [not run] External volumes not in use, skipped this test
xfs/095            [not run] v4 file systems not supported
xfs/096            [not run] v4 file systems not supported
xfs/103             1s
xfs/104             14s
xfs/106             17s
xfs/107            [not run] xfs_io allocsp  failed (old kernel/wrong fs?)
xfs/108             3s
xfs/109             13s
xfs/110             5s
xfs/114             3s
xfs/115             2s
xfs/116             2s
xfs/118             109s
xfs/119             4s
xfs/121             7s
xfs/122            [not run] indent utility required, skipped this test
xfs/127             15s
xfs/128             25s
xfs/129             7s
xfs/131            [not run] XFS error injection requires CONFIG_XFS_DEBUG
xfs/132            [not run] v4 file systems not supported
xfs/135             22s
xfs/137             58s
xfs/138             3s
xfs/139             76s
xfs/140             202s
xfs/141            [not run] XFS error injection requires CONFIG_XFS_DEBUG
xfs/142            [not run] External volumes not in use, skipped this test
xfs/143            [not run] External volumes not in use, skipped this test
xfs/144             2s
xfs/145             1s
xfs/146            [not run] External volumes not in use, skipped this test
xfs/147            [not run] External volumes not in use, skipped this test
xfs/148            [not run] v4 file systems not supported
xfs/149             1s
xfs/150             2s
xfs/151             3s
xfs/152             25s
xfs/153             8s
xfs/154             2s
xfs/155             15s
xfs/156             11s
xfs/157             4s
xfs/158             5s
xfs/159             2s
xfs/160             5s
xfs/161             3s
xfs/162             3s
xfs/163             2s
xfs/164             2s
xfs/165             1s
xfs/166             1s
xfs/167             24s
xfs/168             24s
xfs/169             19s
xfs/170             6s
xfs/174             7s
xfs/175             1s
xfs/176             8s
xfs/177             16s
xfs/178             3s
xfs/179             4s
xfs/180             3s
xfs/181             13s
xfs/182             9s
xfs/183             4s
xfs/184             3s
xfs/185             3s
xfs/186            [not run] attr v1 not supported on /dev/sdb
xfs/187            [not run] External volumes not in use, skipped this test
xfs/188             5s
xfs/189            [not run] noattr2 mount option not supported on /dev/sdb
xfs/190             2s
xfs/191             3s
xfs/192             7s
xfs/193             3s
xfs/194            [not run] v4 file systems not supported
xfs/195            [not run] xfsdump utility required, skipped this test
xfs/196            [not run] XFS error injection requires CONFIG_XFS_DEBUG
xfs/197            [not run] This test is only valid on 32 bit machines
xfs/198             6s
xfs/199            [not run] v4 file systems not supported
xfs/200             5s
xfs/201             7s
xfs/202             1s
xfs/203             2s
xfs/204             8s
xfs/205             3s
xfs/206             1s
xfs/207             3s
xfs/208             4s
xfs/209             2s
xfs/210             2s
xfs/212             3s
xfs/213             3s
xfs/214             3s
xfs/215             3s
xfs/216             3s
xfs/217             6s
xfs/218             3s
xfs/219             3s
xfs/220             2s
xfs/221             3s
xfs/222             40s
xfs/223             4s
xfs/224             4s
xfs/225             3s
xfs/226             3s
xfs/227             34s
xfs/228             4s
xfs/229             11s
xfs/230             4s
xfs/231             5s
xfs/232             7s
xfs/233             49s
xfs/234            =00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00

--KFt0mAB3puHSe9pa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="fstests-auto.log"
Content-Transfer-Encoding: quoted-printable

FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64 hamza-azl3-fstests 6.6.144.1-2.azl3 #1 SMP PR=
EEMPT_DYNAMIC Mon Jul  6 12:10:38 UTC 2026
MKFS_OPTIONS  -- -f /dev/sdb
MOUNT_OPTIONS -- /dev/sdb /mnt/scratch

generic/001         4s
generic/002         1s
generic/003         11s
generic/004         1s
generic/005         1s
generic/006         1s
generic/007         1s
generic/008         1s
generic/009         1s
generic/010        [not run] /home/azureuser/xfstests-dev/src/dbtest not bu=
ilt
generic/011         2s
generic/012         1s
generic/013         5s
generic/014         4s
generic/015         2s
generic/016         1s
generic/017         119s
generic/018         4s
generic/020         4s
generic/021         2s
generic/022         2s
generic/023         1s
generic/024         1s
generic/025         1s
generic/026         3s
generic/027         75s
generic/028         6s
generic/029         2s
generic/030         2s
generic/031         1s
generic/032         7s
generic/033         1s
generic/034         2s
generic/035         1s
generic/036        [not run] /home/azureuser/xfstests-dev/src/aio-dio-regre=
ss/aio-dio-fcntl-race not built
generic/037         6s
generic/038         35s
generic/039         2s
generic/040         10s
generic/041         11s
generic/042         35s
generic/043         16s
generic/044         18s
generic/045         17s
generic/046         18s
generic/047         31s
generic/048         155s
generic/049         12s
generic/050         3s
generic/051         115s
generic/052         2s
generic/053         2s
generic/054         71s
generic/055         47s
generic/056         2s
generic/057         2s
generic/058         1s
generic/059         3s
generic/060         1s
generic/061         1s
generic/062        - output mismatch (see /home/azureuser/xfstests-dev/resu=
lts//generic/062.out.bad)
    --- tests/generic/062.out	2026-07-07 12:16:09.188601915 +0000
    +++ /home/azureuser/xfstests-dev/results//generic/062.out.bad	2026-07-0=
7 19:39:44.410949971 +0000
    @@ -649,6 +649,7 @@
     SCRATCH_MNT/lnk
     SCRATCH_MNT/reg
     *** restore everything
    +Warning: option --restore=3Dfile is unsafe without option -P (--physic=
al) as it traverses symbolic links in pathnames
     *** compare before and after backups
    =20
     *** unmount
    ...
    (Run 'diff -u /home/azureuser/xfstests-dev/tests/generic/062.out /home/=
azureuser/xfstests-dev/results//generic/062.out.bad'  to see the entire dif=
f)
generic/063         1s
generic/064         2s
generic/065         2s
generic/066         2s
generic/067         2s
generic/068         45s
generic/069         5s
generic/070         3s
generic/071         3s
generic/072         13s
generic/073         2s
generic/074         98s
generic/075         18s
generic/076         4s
generic/077         8s
generic/078         1s
generic/079         1s
generic/080         3s
generic/081         4s
generic/082         2s
generic/083         14s
generic/084         8s
generic/085         11s
generic/086         1s
generic/087         0s
generic/088         1s
generic/089         4s
generic/090         2s
generic/091         48s
generic/092         0s
generic/093         1s
generic/094         54s
generic/095        [not run] kernel does not support asynchronous I/O
generic/096         1s
generic/097         1s
generic/098         2s
generic/099         1s
generic/100         14s
generic/101         2s
generic/102         3s
generic/103         2s
generic/104         1s
generic/105         2s
generic/106         2s
generic/107         2s
generic/108         3s
generic/109         2s
generic/110         1s
generic/111         1s
generic/112        [not run] kernel does not support asynchronous I/O
generic/113        [not run] kernel does not support asynchronous I/O
generic/114        [not run] /home/azureuser/xfstests-dev/src/aio-dio-regre=
ss/aio-dio-eof-race not built
generic/115         1s
generic/116         1s
generic/117         4s
generic/118         2s
generic/119         1s
generic/120         16s
generic/121         2s
generic/122         1s
generic/123         1s
generic/124         3s
generic/125         62s
generic/126         1s
generic/127         268s
generic/128         2s
generic/129         7s
generic/130         11s
generic/131         1s
generic/132         11s
generic/133         105s
generic/134         1s
generic/135         1s
generic/136         2s
generic/137         15s
generic/138         1s
generic/139         2s
generic/140         1s
generic/141         1s
generic/142         3s
generic/143         49s
generic/144         2s
generic/145         1s
generic/146         1s
generic/147         1s
generic/148         1s
generic/149         2s
generic/150         1s
generic/151         1s
generic/152         2s
generic/153         1s
generic/154         2s
generic/155         6s
generic/156         2s
generic/157         3s
generic/158         2s
generic/159         1s
generic/160         1s
generic/161         5s
generic/162         18s
generic/163         31s
generic/164         7s
generic/165         18s
generic/166         43s
generic/167         8s
generic/168         39s
generic/169         2s
generic/170         86s
generic/171         3s
generic/172         8s
generic/173         3s
generic/174         4s
generic/175         94s
generic/176         212s
generic/177         2s
generic/178         2s
generic/179         1s
generic/180         2s
generic/181         1s
generic/182         3s
generic/183         3s
generic/184         1s
generic/185         3s
generic/186         20s
generic/187         18s
generic/188         3s
generic/189         3s
generic/190         3s
generic/191         3s
generic/192         6s
generic/193         2s
generic/194         3s
generic/195         4s
generic/196         3s
generic/197         3s
generic/198        [not run] /home/azureuser/xfstests-dev/src/aio-dio-regre=
ss/aiodio_sparse2 not built
generic/199         4s
generic/200         3s
generic/201         3s
generic/202         3s
generic/203         2s
generic/204         18s
generic/205         2s
generic/206         3s
generic/207        [not run] /home/azureuser/xfstests-dev/src/aio-dio-regre=
ss/aio-dio-extend-stat not built
generic/208        [not run] /home/azureuser/xfstests-dev/src/aio-dio-regre=
ss/aio-dio-invalidate-failure not built
generic/209        [not run] /home/azureuser/xfstests-dev/src/aio-dio-regre=
ss/aio-dio-invalidate-readahead not built
generic/210        [not run] /home/azureuser/xfstests-dev/src/aio-dio-regre=
ss/aio-dio-subblock-eof-read not built
generic/211         7s
generic/212        [not run] /home/azureuser/xfstests-dev/src/aio-dio-regre=
ss/aio-io-setup-with-nonwritable-context-pointer not built
generic/213         1s
generic/214         1s
generic/215         3s
generic/216         5s
generic/217         5s
generic/218         3s
generic/219         2s
generic/220         2s
generic/221         2s
generic/222         2s
generic/223         8s
generic/224         31s
generic/225         103s
generic/226         8s
generic/227         2s
generic/228         1s
generic/229         8s
generic/230         14s
generic/231         87s
generic/232         12s
generic/233         14s
generic/234         17s
generic/235         1s
generic/236         2s
generic/237         1s
generic/238         8s
generic/239        [not run] /home/azureuser/xfstests-dev/src/aio-dio-regre=
ss/aio-dio-hole-filling-race not built
generic/240        [not run] /home/azureuser/xfstests-dev/src/aio-dio-regre=
ss/aiodio_sparse2 not built
generic/241        [not run] dbench not found
generic/242         49s
generic/243         51s
generic/244         5s
generic/245         2s
generic/246         0s
generic/247         22s
generic/248         1s
generic/249         1s
generic/250         3s
generic/251         36s
generic/252        [not run] /home/azureuser/xfstests-dev/src/aio-dio-regre=
ss/aiocp not built
generic/253         3s
generic/254         3s
generic/255         2s
generic/256         31s
generic/257         1s
generic/258         1s
generic/259         3s
generic/260         51s
generic/261         12s
generic/262         6s
generic/263         31s
generic/264         3s
generic/265         4s
generic/266         3s
generic/267         9s
generic/268         9s
generic/269         24s
generic/270         52s
generic/271         4s
generic/272         4s
generic/273         7s
generic/274         15s
generic/275         26s
generic/276         3s
generic/277         3s
generic/278         4s
generic/279         3s
generic/280         4s
generic/281         10s
generic/282         6s
generic/283         4s
generic/284         3s
generic/285         1s
generic/286         1s
generic/287         3s
generic/288         1s
generic/289         3s
generic/290         3s
generic/291         3s
generic/292         3s
generic/293         4s
generic/294         1s
generic/295         4s
generic/296         3s
generic/297         51s
generic/298         51s
generic/299        [not run] kernel does not support asynchronous I/O
generic/300        [not run] kernel does not support asynchronous I/O
generic/301         3s
generic/302         26s
generic/303         1s
generic/304         1s
generic/305         2s
generic/306         2s
generic/307         3s
generic/308         1s
generic/309         2s
generic/310         64s
generic/311         175s
generic/312         1s
generic/313         5s
generic/314         1s
generic/315         1s
generic/316         1s
generic/317         1s
generic/318         2s
generic/319         1s
generic/320         27s
generic/321         3s
generic/322         3s
generic/323        [not run] /home/azureuser/xfstests-dev/src/aio-dio-regre=
ss/aio-last-ref-held-by-io not built
generic/324         13s
generic/325         2s
generic/326         3s
generic/327         2s
generic/328         3s
generic/329        [not run] /home/azureuser/xfstests-dev/src/aio-dio-regre=
ss/aiocp not built
generic/330        [not run] /home/azureuser/xfstests-dev/src/aio-dio-regre=
ss/aiocp not built
generic/331        [not run] /home/azureuser/xfstests-dev/src/aio-dio-regre=
ss/aiocp not built
generic/332        [not run] /home/azureuser/xfstests-dev/src/aio-dio-regre=
ss/aiocp not built
generic/333         21s
generic/334         9s
generic/335         2s
generic/336         2s
generic/337         1s
generic/338         2s
generic/339         4s
generic/340         2s
generic/341         2s
generic/342         2s
generic/343         2s
generic/344         2s
generic/345         4s
generic/346         2s
generic/347         68s
generic/348         2s
generic/352         16s
generic/353         2s
generic/354         3s
generic/355         2s
generic/356         3s
generic/357         6s
generic/358         12s
generic/359         4s
generic/360         1s
generic/361         4s
generic/362         1s
generic/363        [failed, exit status 1]- output mismatch (see /home/azur=
euser/xfstests-dev/results//generic/363.out.bad)
    --- tests/generic/363.out	2026-07-07 12:16:09.204601825 +0000
    +++ /home/azureuser/xfstests-dev/results//generic/363.out.bad	2026-07-0=
7 20:34:03.815830171 +0000
    @@ -1,2 +1,404 @@
     QA output created by 363
     fsx -q -S 0 -e 1 -N 100000
    +READ BAD DATA: offset =3D 0x1c1b1, size =3D 0xe05b, fname =3D /mnt/tes=
t/junk
    +OFFSET      GOOD    BAD     RANGE
    +0x29227     0x0000  0x7a6b  0x0
    +operation# (mod 256) for the bad data may be 107
    +0x29228     0x0000  0x6b24  0x1
    ...
    (Run 'diff -u /home/azureuser/xfstests-dev/tests/generic/363.out /home/=
azureuser/xfstests-dev/results//generic/363.out.bad'  to see the entire dif=
f)
generic/364         11s
generic/365        - output mismatch (see /home/azureuser/xfstests-dev/resu=
lts//generic/365.out.bad)
    --- tests/generic/365.out	2026-07-07 12:16:09.204601825 +0000
    +++ /home/azureuser/xfstests-dev/results//generic/365.out.bad	2026-07-0=
7 20:34:16.871752975 +0000
    @@ -2,14 +2,12 @@
     test incorrect setting of high key
     	XXXX: XXXX:XXXX [XXXX..XXXX]: USED XXXX
     test missing free space extent
    -	XXXX: XXXX:XXXX [XXXX..XXXX]: FREE XXXX
     test whatever came before freesp
     	XXXX: XXXX:XXXX [XXXX..XXXX]: USED XXXX
     test whatever came after freesp
    ...
    (Run 'diff -u /home/azureuser/xfstests-dev/tests/generic/365.out /home/=
azureuser/xfstests-dev/results//generic/365.out.bad'  to see the entire dif=
f)

HINT: You _MAY_ be missing kernel fix:
      68415b349f3f xfs: Fix the owner setting issue for rmap query in xfs f=
smap

HINT: You _MAY_ be missing kernel fix:
      ca6448aed4f1 xfs: Fix missing interval for missing_owner in xfs fsmap

generic/366        [not run] kernel does not support asynchronous I/O
generic/368        [not run] filesystem doesn't support -o inlinecrypt
generic/369        [not run] filesystem doesn't support -o inlinecrypt
generic/370         6s
generic/371         20s
generic/372         4s
generic/373         2s
generic/374         2s
generic/375         1s
generic/376         2s
generic/377         2s
generic/378         1s
generic/379         4s
generic/380         4s
generic/381         3s
generic/382         8s
generic/383         4s
generic/384         2s
generic/385         3s
generic/386         3s
generic/387         32s
generic/388         500s
generic/389         1s
generic/390         2s
generic/391         3s
generic/392         11s
generic/393         5s
generic/394         1s
generic/395        [not run] No encryption support for xfs
generic/396        [not run] No encryption support for xfs
generic/397        [not run] No encryption support for xfs
generic/398        [not run] No encryption support for xfs
generic/399        [not run] No encryption support for xfs
generic/400         3s
generic/401         3s
generic/402         5s
generic/403         3s
generic/404         36s
generic/405         63s
generic/406         3s
generic/407         2s
generic/408         2s
generic/409         19s
generic/410         38s
generic/411         2s
generic/412         1s
generic/413        [not run] /dev/sdb xfs does not support -o dax
generic/414         3s
generic/415         110s
generic/416         69s
generic/417         15s
generic/418         22s
generic/419        [not run] No encryption support for xfs
generic/420         1s
generic/421        [not run] No encryption support for xfs
generic/422         2s
generic/423         1s
generic/424         1s
generic/425         2s
generic/426         2s
generic/427        [not run] /home/azureuser/xfstests-dev/src/aio-dio-regre=
ss/aio-dio-eof-race not built
generic/428         1s
generic/429        [not run] No encryption support for xfs
generic/430         1s
generic/431         1s
generic/432         0s
generic/433         1s
generic/434         1s
generic/435        [not run] No encryption support for xfs
generic/436         1s
generic/437         2s
generic/438         679s
generic/439         2s
generic/440        [not run] No encryption support for xfs
generic/441         1s
generic/443         1s
generic/444         1s
generic/445         1s
generic/446         9s
generic/447         177s
generic/448         1s
generic/449         32s
generic/450         1s
generic/451        [not run] /home/azureuser/xfstests-dev/src/aio-dio-regre=
ss/aio-dio-cycle-write not built
generic/452         1s
generic/453         2s
generic/454         2s
generic/455        [not run] This test requires a valid $LOGWRITES_DEV
generic/456         2s
generic/457        [not run] This test requires a valid $LOGWRITES_DEV
generic/458         2s
generic/459        [not run] thin_check utility required, skipped this test
generic/460         15s
generic/461         24s
generic/462        [not run] /dev/sdb xfs does not support -o dax
generic/463        [not run] /home/azureuser/xfstests-dev/src/aio-dio-regre=
ss/aio-dio-cow-race not built
generic/464         65s
generic/465        [not run] /home/azureuser/xfstests-dev/src/aio-dio-regre=
ss/aio-dio-append-write-read-race not built
generic/466         7s
generic/467         2s
generic/468         5s
generic/469         1s
generic/470        [not run] This test requires a valid $LOGWRITES_DEV
generic/471         1s
generic/472         2s
generic/474         2s
generic/475         441s
generic/476         85s
generic/477         3s
generic/478         10s
generic/479         5s
generic/480         1s
generic/481         2s
generic/482        [not run] This test requires a valid $LOGWRITES_DEV
generic/483         4s
generic/484         2s
generic/485         1s
generic/486         2s
generic/487        [not run] This test requires a valid $SCRATCH_LOGDEV
generic/488         2s
generic/489         2s
generic/490         1s
generic/491         1s
generic/492         2s
generic/493         3s
generic/494         2s
generic/495         3s
generic/496         2s
generic/497         3s
generic/498         2s
generic/499         1s
generic/500         26s
generic/501         84s
generic/502         2s
generic/503         6s
generic/504         1s
generic/505         2s
generic/506         3s
generic/507         7s
generic/508         3s
generic/509         2s
generic/510         2s
generic/511         3s
generic/512         2s
generic/513         3s
generic/514         2s
generic/515         5s
generic/516         1s
generic/517         2s
generic/518         3s
generic/519         1s
generic/520         33s
generic/523         2s
generic/524         17s
generic/525         4s
generic/526         2s
generic/527         2s
generic/528         1s
generic/529         1s
generic/530         13s
generic/531         17s
generic/532         1s
generic/533         1s
generic/534         4s
generic/535         3s
generic/536         2s
generic/537         2s
generic/538        [not run] /home/azureuser/xfstests-dev/src/aio-dio-regre=
ss/aio-dio-write-verify not built
generic/539         1s
generic/540         4s
generic/541         3s
generic/542         5s
generic/543         9s
generic/544         8s
generic/545         1s
generic/546         5s
generic/547         4s
generic/548        [not run] No encryption support for xfs
generic/549        [not run] No encryption support for xfs
generic/550        [not run] No encryption support for xfs
generic/551        [not run] /home/azureuser/xfstests-dev/src/aio-dio-regre=
ss/aio-dio-write-verify not built
generic/552         2s
generic/553         1s
generic/554         2s
generic/555         1s
generic/556        [not run] xfs does not support casefold feature
generic/557         1s
generic/558         67s
generic/559        [not run] duperemove utility required, skipped this test
generic/560        [not run] duperemove utility required, skipped this test
generic/561        [not run] duperemove utility required, skipped this test
generic/562         63s
generic/563         3s
generic/564         1s
generic/565        [not run] xfs does not support cross-device copy_file_ra=
nge
generic/566         1s
generic/567         2s
generic/568         1s
generic/569         2s
generic/570        [not run] userspace hibernation to swap is enabled
generic/571         7s
generic/572        [not run] fsverity utility required, skipped this test
generic/573        [not run] fsverity utility required, skipped this test
generic/574        [not run] fsverity utility required, skipped this test
generic/575        [not run] fsverity utility required, skipped this test
generic/576        [not run] fsverity utility required, skipped this test
generic/577        [not run] fsverity utility required, skipped this test
generic/578         2s
generic/579        [not run] fsverity utility required, skipped this test
generic/580        [not run] No encryption support for xfs
generic/581        [not run] No encryption support for xfs
generic/582        [not run] No encryption support for xfs
generic/583        [not run] No encryption support for xfs
generic/584        [not run] No encryption support for xfs
generic/585         2s
generic/586        [not run] /home/azureuser/xfstests-dev/src/aio-dio-regre=
ss/aio-dio-append-write-fallocate-race not built
generic/587         3s
generic/588         3s
generic/589         11s
generic/590         129s
generic/591         1s
generic/592        [not run] No encryption support for xfs
generic/593        [not run] No encryption support for xfs
generic/594         3s
generic/595        [not run] No encryption support for xfs
generic/596        [not run] accton utility required, skipped this test
generic/597         1s
generic/598         2s
generic/599         2s
generic/600         4s
generic/601         5s
generic/602        [not run] No encryption support for xfs
generic/603         52s
generic/604         2s
generic/605        [not run] /dev/sdb xfs does not support -o dax=3Dalways
generic/606        [not run] /dev/sdb xfs does not support -o dax=3Dalways
generic/607         2s
generic/608        [not run] /dev/sdb xfs does not support -o dax=3Dalways
generic/609         1s
generic/610         2s
generic/611         2s
generic/612         1s
generic/613        [not run] No encryption support for xfs
generic/614         2s
generic/615         19s
generic/616        [not run] kernel does not support IO_URING
generic/617        [not run] kernel does not support IO_URING
generic/618         2s
generic/619         24s
generic/620         15s
generic/621        [not run] No encryption support for xfs
generic/622         28s
generic/623         2s
generic/624        [not run] fsverity utility required, skipped this test
generic/625        [not run] fsverity utility required, skipped this test
generic/626         2s
generic/627        [not run] kernel does not support asynchronous I/O
generic/628         4s
generic/629         3s
generic/630         32s
generic/631         32s
generic/632         1s
generic/633         1s
generic/634         2s
generic/635         2s
generic/636         2s
generic/637         1s
generic/638         1s
generic/639         1s
generic/640         2s
generic/641         3s
generic/642         214s
generic/643         2s
generic/644         1s
generic/645        [failed, exit status 1]- output mismatch (see /home/azur=
euser/xfstests-dev/results//generic/645.out.bad)
    --- tests/generic/645.out	2026-07-07 12:16:09.216601757 +0000
    +++ /home/azureuser/xfstests-dev/results//generic/645.out.bad	2026-07-0=
7 21:37:19.113261923 +0000
    @@ -1,2 +1,4 @@
     QA output created by 645
     Silence is golden
    +idmapped-mounts.c: 6671: nested_userns - Success - failure: sys_mount_=
setattr
    +vfstest.c: 2418: run_test - Success - failure: test that nested user n=
amespaces behave correctly when attached to idmapped mounts
    ...
    (Run 'diff -u /home/azureuser/xfstests-dev/tests/generic/645.out /home/=
azureuser/xfstests-dev/results//generic/645.out.bad'  to see the entire dif=
f)

This test wants kernel fix:
      dacfd001eaf2 fs/mnt_idmapping.c: Return -EINVAL when no map is written

generic/646         2s
generic/647         1s
generic/648         176s
generic/649         2s
generic/650         47s
generic/651         2s
generic/652         2s
generic/653         3s
generic/654         2s
generic/655         6s
generic/656         1s
generic/657         3s
generic/658         3s
generic/659         3s
generic/660         3s
generic/661         4s
generic/662         3s
generic/663         3s
generic/664         3s
generic/665         3s
generic/666         4s
generic/667         4s
generic/668         3s
generic/669         4s
generic/670         7s
generic/671         17s
generic/672         41s
generic/673         4s
generic/674         4s
generic/675         3s
generic/676         2s
generic/677         7s
generic/678        [not run] kernel does not support IO_URING
generic/679        [not run] not suitable for this filesystem type: xfs
generic/680         1s
generic/681         2s
generic/682         3s
generic/683         2s
generic/684         1s
generic/685         2s
generic/686         1s
generic/687         2s
generic/688         1s
generic/689         0s
generic/690         1s
generic/691         25s
generic/692        [not run] fsverity utility required, skipped this test
generic/693        [not run] No encryption support for xfs
generic/694         1s
generic/695         2s
generic/696         2s
generic/697         0s
generic/698         2s
generic/699         2s
generic/700        [not run] Require selinux to be enabled
generic/701         1s
generic/702         2s
generic/703        [not run] kernel does not support IO_URING
generic/704         3s
generic/705         17s
generic/706         1s
generic/707         65s
generic/708         1s
generic/709        [not run] xfs_io exchangerange  support is missing
generic/710        [not run] xfs_io exchangerange  support is missing
generic/711         3s
generic/712        [not run] xfs_io exchangerange  support is missing
generic/713        [not run] xfs_io exchangerange  -s 64k -l 64k support is=
 missing
generic/714        [not run] xfs_io exchangerange  support is missing
generic/715        [not run] xfs_io exchangerange  -s 64k -l 64k support is=
 missing
generic/716        [not run] xfs_io exchangerange  support is missing
generic/717        [not run] xfs_io exchangerange  support is missing
generic/718        [not run] xfs_io exchangerange  support is missing
generic/719        [not run] xfs_io exchangerange  support is missing
generic/720        [not run] xfs_io exchangerange  support is missing
generic/721        [not run] xfs_io startupdate  support is missing
generic/722        [not run] xfs_io exchangerange  support is missing
generic/723        [not run] xfs_io exchangerange  support is missing
generic/724        [not run] xfs_io exchangerange  support is missing
generic/725        [not run] xfs_io exchangerange  support is missing
generic/726        [not run] xfs_io exchangerange  support is missing
generic/727        [not run] xfs_io exchangerange  support is missing
generic/728         5s
generic/729         1s
generic/730         3s
generic/731         2s
generic/732         2s
generic/733         9s
generic/734         1s
generic/735         1s
generic/736         1s
generic/737        [not run] /home/azureuser/xfstests-dev/src/aio-dio-regre=
ss/aio-dio-write-verify not built
generic/738         13s
generic/739        [not run] No encryption support for xfs
generic/740         45s
generic/741         3s
generic/742         10s
generic/743        [not run] xfs_io madvise doesn't support -R
generic/744        [not run] xfs does not support duplicate fsid
generic/745         13s
generic/746         40s
generic/747         107s
generic/748         57s
generic/749         6s
generic/750         44s
generic/751         116s
generic/752        [not run] xfs_io exchangerange  support is missing
generic/753        _check_xfs_filesystem: filesystem on /dev/sdb is inconsi=
stent (r)
(see /home/azureuser/xfstests-dev/results//generic/753.full for details)

generic/754        _check_xfs_filesystem: filesystem on /dev/sdb is inconsi=
stent (r)
(see /home/azureuser/xfstests-dev/results//generic/754.full for details)


HINT: You _MAY_ be missing kernel fix:
      38de567906d95 xfs: allow symlinks with short remote targets

HINT: You _MAY_ be missing xfsprogs fix:
      XXXXXXXXXXXXX xfs_repair: small remote symlinks are ok

generic/755         3s
generic/756        [not run] statx does not support STATX_MNT_ID_UNIQUE on =
this kernel
generic/757        [not run] aio-dio utilities required
generic/758         1s
generic/759         31s
generic/760         28s
generic/761         27s
generic/762         2s
generic/763         1s
generic/764         1s
generic/765        [not run] write atomic not supported by this block device
generic/766        [not run] This test requires a valid $SCRATCH_LOGDEV
generic/767        [not run] write atomic not supported by this block device
generic/768        [not run] xfs_io pwrite doesn't support -A
generic/769        [not run] xfs_io pwrite doesn't support -A
generic/770        [not run] xfs_io pwrite doesn't support -A
generic/771         2s
generic/772        [not run] /home/azureuser/xfstests-dev/src/file_attr not=
 built
generic/773        [not run] write atomic not supported by this block device
generic/774        [not run] kernel does not support asynchronous I/O
generic/775        [not run] xfs_io pwrite doesn't support -A
generic/776        [not run] write atomic not supported by this block device
generic/777        [not run] xfs does not support connectable file handles
generic/778        [not run] xfs_io pwrite doesn't support -A
generic/779         1s
generic/781        [not run] This test requires zoned loopback device suppo=
rt
generic/782         1s
generic/783        [not run] xfs does not support casefold feature
generic/784         2s
generic/785         1s
generic/786        [not run] Require fcntl setdeleg support
generic/787        [not run] Require fcntl setdeleg support
generic/788        [not run] fsverity utility required, skipped this test
generic/789         1s
generic/790         2s
generic/791        [not run] xfs_io healthmon -p support is missing
generic/792         2s
generic/793        [not run] this test requires a zoned block device
generic/794        - output mismatch (see /home/azureuser/xfstests-dev/resu=
lts//generic/794.out.bad)
    --- tests/generic/794.out	2026-07-07 12:16:09.224601711 +0000
    +++ /home/azureuser/xfstests-dev/results//generic/794.out.bad	2026-07-0=
7 21:57:37.725999223 +0000
    @@ -1,4 +1,8 @@
     QA output created by 794
     append_write
    +FAIL: non-zero data in gap [4080,4096) after shutdown+remount
    +000000 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  >ZZZZZZZZZZZZZ=
ZZZ<
    +*
    +001000
     truncate_up
    ...
    (Run 'diff -u /home/azureuser/xfstests-dev/tests/generic/794.out /home/=
azureuser/xfstests-dev/results//generic/794.out.bad'  to see the entire dif=
f)
xfs/001             6s
xfs/002            [not run] v4 file systems not supported
xfs/003             1s
xfs/004             1s
xfs/005             1s
xfs/006             4s
xfs/007             3s
xfs/008             1s
xfs/009             1s
xfs/010             4s
xfs/011             18s
xfs/012             1s
xfs/013             96s
xfs/014             8s
xfs/015             5s
xfs/016            [not run] Cannot run this test using log MKFS_OPTIONS sp=
ecified
xfs/017             7s
xfs/018            [not run] XFS error injection requires CONFIG_XFS_DEBUG
xfs/019             4s
xfs/020             1s
xfs/021             3s
xfs/026            [not run] xfsdump not found
xfs/027            [not run] xfsdump not found
xfs/028            [not run] xfsdump not found
xfs/029             4s
xfs/030             19s
xfs/031             9s
xfs/032             42s
xfs/033             7s
xfs/034             2s
xfs/035            [not run] xfsdump not found
xfs/040            [not run] Can't run libxfs-diff without KWORKAREA set
xfs/041             19s
xfs/042             24s
xfs/044            [not run] This test requires a valid $SCRATCH_LOGDEV
xfs/045             5s
xfs/046            [not run] xfsdump not found
xfs/047            [not run] xfsdump not found
xfs/048             0s
xfs/049             13s
xfs/050             10s
xfs/051            [not run] sysfs attribute 'debug/log_recovery_delay' is =
not supported
xfs/052             1s
xfs/053             2s
xfs/054             1s
xfs/056            [not run] xfsdump not found
xfs/057            [not run] XFS error injection requires CONFIG_XFS_DEBUG
xfs/058             2s
xfs/059            [not run] xfsdump not found
xfs/060            [not run] xfsdump not found
xfs/061            [not run] xfsdump not found
xfs/062             6s
xfs/063            [not run] xfsdump not found
xfs/064            [not run] xfsdump not found
xfs/065            [not run] xfsdump not found
xfs/066            [not run] xfsdump not found
xfs/067             2s
xfs/068            [not run] xfsdump not found
xfs/069             3s
xfs/070             2s
xfs/071             2s
xfs/072             1s
xfs/073             29s
xfs/074             1s
xfs/075             1s
xfs/076             10s
xfs/077             18s
xfs/078             7s
xfs/079             30s
xfs/080             3s
xfs/081             6s
xfs/082             1s
xfs/084             60s
xfs/090            [not run] External volumes not in use, skipped this test
xfs/092             2s
xfs/094            [not run] External volumes not in use, skipped this test
xfs/095            [not run] v4 file systems not supported
xfs/096            [not run] v4 file systems not supported
xfs/103             2s
xfs/104             13s
xfs/106             18s
xfs/107            [not run] xfs_io allocsp  failed (old kernel/wrong fs?)
xfs/108             3s
xfs/109             13s
xfs/110             5s
xfs/114             3s
xfs/115             2s
xfs/116             2s
xfs/118             109s
xfs/119             4s
xfs/121             7s
xfs/122            [not run] indent utility required, skipped this test
xfs/127             15s
xfs/128             25s
xfs/129             7s
xfs/131            [not run] XFS error injection requires CONFIG_XFS_DEBUG
xfs/132            [not run] v4 file systems not supported
xfs/135             28s
xfs/137             60s
xfs/138             4s
xfs/139             75s
xfs/140             190s
xfs/141            [not run] XFS error injection requires CONFIG_XFS_DEBUG
xfs/142            [not run] External volumes not in use, skipped this test
xfs/143            [not run] External volumes not in use, skipped this test
xfs/144             3s
xfs/145             1s
xfs/146            [not run] External volumes not in use, skipped this test
xfs/147            [not run] External volumes not in use, skipped this test
xfs/148            [not run] v4 file systems not supported
xfs/149             1s
xfs/150             2s
xfs/151             3s
xfs/152             25s
xfs/153             7s
xfs/154             3s
xfs/155             14s
xfs/156             12s
xfs/157             4s
xfs/158             5s
xfs/159             2s
xfs/160             4s
xfs/161             7s
xfs/162             7s
xfs/163             7s
xfs/164             1s
xfs/165             1s
xfs/166             1s
xfs/167             23s
xfs/168             26s
xfs/169             18s
xfs/170             6s
xfs/174             7s
xfs/175             2s
xfs/176             8s
xfs/177             16s
xfs/178             3s
xfs/179             3s
xfs/180             4s
xfs/181             13s
xfs/182             9s
xfs/183             3s
xfs/184             4s
xfs/185             3s
xfs/186            [not run] attr v1 not supported on /dev/sdb
xfs/187            [not run] External volumes not in use, skipped this test
xfs/188             5s
xfs/189            [not run] noattr2 mount option not supported on /dev/sdb
xfs/190             1s
xfs/191             2s
xfs/192             8s
xfs/193             3s
xfs/194            [not run] v4 file systems not supported
xfs/195            [not run] xfsdump utility required, skipped this test
xfs/196            [not run] XFS error injection requires CONFIG_XFS_DEBUG
xfs/197            [not run] This test is only valid on 32 bit machines
xfs/198             5s
xfs/199            [not run] v4 file systems not supported
xfs/200             5s
xfs/201             7s
xfs/202             2s
xfs/203             2s
xfs/204             7s
xfs/205             3s
xfs/206             1s
xfs/207             3s
xfs/208             3s
xfs/209             3s
xfs/210             2s
xfs/212             3s
xfs/213             3s
xfs/214             3s
xfs/215             3s
xfs/216             4s
xfs/217             5s
xfs/218             3s
xfs/219             3s
xfs/220             2s
xfs/221             3s
xfs/222             29s
xfs/223             3s
xfs/224             4s
xfs/225             3s
xfs/226             3s
xfs/227             37s
xfs/228             4s
xfs/229             11s
xfs/230             3s
xfs/231             6s
xfs/232             7s
xfs/233             49s
xfs/234             72s
xfs/235             8s
xfs/236             11s
xfs/237            [not run] /home/azureuser/xfstests-dev/src/aio-dio-regre=
ss/aiocp not built
xfs/238             2s
xfs/239            [not run] /home/azureuser/xfstests-dev/src/aio-dio-regre=
ss/aiocp not built
xfs/240            [not run] /home/azureuser/xfstests-dev/src/aio-dio-regre=
ss/aiocp not built
xfs/241            [not run] /home/azureuser/xfstests-dev/src/aio-dio-regre=
ss/aiocp not built
xfs/242             1s
xfs/243            [not run] Require XFS built with CONFIG_XFS_DEBUG
xfs/244            [not run] 16 bit project IDs not supported on /dev/sdb
xfs/245            [not run] Require XFS built with CONFIG_XFS_DEBUG
xfs/246            [not run] Require XFS built with CONFIG_XFS_DEBUG
xfs/247             2s
xfs/248             3s
xfs/249             3s
xfs/250             88s
xfs/251             2s
xfs/252             2s
xfs/253             5s
xfs/254             3s
xfs/255             3s
xfs/256             3s
xfs/257             4s
xfs/258             4s
xfs/259             4s
xfs/260             1s
xfs/261             2s
xfs/263             2s
xfs/264             6s
xfs/265             9s
xfs/266            [not run] xfsdump not found
xfs/269             1s
xfs/270             4s
xfs/271             4s
xfs/272             4s
xfs/273            - output mismatch (see /home/azureuser/xfstests-dev/resu=
lts//xfs/273.out.bad)
    --- tests/xfs/273.out	2026-07-07 12:16:09.244601597 +0000
    +++ /home/azureuser/xfstests-dev/results//xfs/273.out.bad	2026-07-07 22=
:30:08.038439301 +0000
    @@ -1,3 +1,4 @@
     QA output created by 273
     Format and mount
     Compare fsmap
    +8:10h: fsmap stops at 134217720, expected 134217728
    ...
    (Run 'diff -u /home/azureuser/xfstests-dev/tests/xfs/273.out /home/azur=
euser/xfstests-dev/results//xfs/273.out.bad'  to see the entire diff)

HINT: You _MAY_ be missing kernel fix:
      a440a28ddbdc xfs: fix off-by-one error in fsmap

xfs/274             4s
xfs/275            [not run] This test requires a valid $SCRATCH_LOGDEV
xfs/276            [not run] External volumes not in use, skipped this test
xfs/277             3s
xfs/278             2s
xfs/279             5s
xfs/280             2s
xfs/281            [not run] xfsdump not found
xfs/282            [not run] xfsdump not found
xfs/283            [not run] xfsdump not found
xfs/284             5s
xfs/285            [not run] xfs_io scrub support is missing
xfs/286            [not run] xfs_io scrub support is missing
xfs/287            [not run] xfsdump not found
xfs/288             1s
xfs/289             1s
xfs/290             1s
xfs/291             47s
xfs/292             1s
xfs/293            [not run] man utility required, skipped this test
xfs/294             78s
xfs/295             10s
xfs/296            [not run] xfsdump not found
xfs/297             70s
xfs/298             8s
xfs/299            - output mismatch (see /home/azureuser/xfstests-dev/resu=
lts//xfs/299.out.bad)
    --- tests/xfs/299.out	2026-07-07 12:16:09.244601597 +0000
    +++ /home/azureuser/xfstests-dev/results//xfs/299.out.bad	2026-07-07 22=
:34:16.164980169 +0000
    @@ -136,7 +136,7 @@
    =20
    =20
     *** report no quota settings
    -[ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
    +[ROOT] 0 0 0 00 [--------] 17 0 0 00 [--------] 0 0 0 00 [--------]
    =20
     *** report initial settings
    ...
    (Run 'diff -u /home/azureuser/xfstests-dev/tests/xfs/299.out /home/azur=
euser/xfstests-dev/results//xfs/299.out.bad'  to see the entire diff)
xfs/300            [not run] v4 file systems not supported
xfs/301            [not run] xfsdump not found
xfs/302            [not run] xfsdump not found
xfs/303             1s
xfs/304             1s
xfs/305             83s
xfs/306             8s
xfs/307             4s
xfs/308             4s
xfs/309             10s
xfs/310             4s
xfs/311             22s
xfs/312            [not run] XFS error injection requires CONFIG_XFS_DEBUG
xfs/313            [not run] XFS error injection requires CONFIG_XFS_DEBUG
xfs/314            [not run] XFS error injection requires CONFIG_XFS_DEBUG
xfs/315            [not run] XFS error injection requires CONFIG_XFS_DEBUG
xfs/316            [not run] XFS error injection requires CONFIG_XFS_DEBUG
xfs/317            [not run] XFS error injection requires CONFIG_XFS_DEBUG
xfs/318            [not run] XFS error injection requires CONFIG_XFS_DEBUG
xfs/319            [not run] XFS error injection requires CONFIG_XFS_DEBUG
xfs/320            [not run] XFS error injection requires CONFIG_XFS_DEBUG
xfs/321            [not run] XFS error injection requires CONFIG_XFS_DEBUG
xfs/322            [not run] XFS error injection requires CONFIG_XFS_DEBUG
xfs/323            [not run] XFS error injection requires CONFIG_XFS_DEBUG
xfs/324            [not run] XFS error injection requires CONFIG_XFS_DEBUG
xfs/325            [not run] XFS error injection requires CONFIG_XFS_DEBUG
xfs/326            [not run] XFS error injection requires CONFIG_XFS_DEBUG
xfs/327             3s
xfs/328             23s
xfs/329            [not run] XFS error injection requires CONFIG_XFS_DEBUG
xfs/330             2s
xfs/331             4s
xfs/332             3s
xfs/334            [not run] External volumes not in use, skipped this test
xfs/335            [not run] External volumes not in use, skipped this test
xfs/336            [not run] External volumes not in use, skipped this test
xfs/338            [not run] External volumes not in use, skipped this test
xfs/339            [not run] External volumes not in use, skipped this test
xfs/340            [not run] External volumes not in use, skipped this test
xfs/341            [not run] External volumes not in use, skipped this test
xfs/342            [not run] External volumes not in use, skipped this test
xfs/343            [not run] External volumes not in use, skipped this test
xfs/344             7s
xfs/345             3s
xfs/346             35s
xfs/347             7s
xfs/348             18s
xfs/349            [not run] xfs_io scrub support is missing
xfs/419            [not run] External volumes not in use, skipped this test
xfs/420             3s
xfs/421             3s
xfs/424             5s
xfs/431             1s
xfs/432             13s
xfs/433            [not run] XFS error injection requires CONFIG_XFS_DEBUG
xfs/434            [not run] XFS error injection requires CONFIG_XFS_DEBUG
xfs/435             3s
xfs/436            [not run] XFS error injection requires CONFIG_XFS_DEBUG
xfs/437            [not run] Can't run find-api-violations.sh without WORKA=
REA set
xfs/438             4s
xfs/439             1s
xfs/440             3s
xfs/441             3s
xfs/442             58s
xfs/443            [not run] xfs_io exchangerange  support is missing
xfs/444             27s
xfs/445             17s
xfs/446            [not run] checkbashisms utility required, skipped this t=
est
xfs/447            [not run] sysfs attribute 'debug/mount_delay' is not sup=
ported
xfs/448            [not run] xfs_io scrub support is missing
xfs/449             1s
xfs/450             2s
xfs/451             2s
xfs/452             1s
xfs/490            [not run] v4 file systems not supported
xfs/491             2s
xfs/492             1s
xfs/493             1s
xfs/494             1s
xfs/495             37s
xfs/499             1s
xfs/500             0s
xfs/501            [not run] XFS error injection requires CONFIG_XFS_DEBUG
xfs/502            [not run] XFS error injection requires CONFIG_XFS_DEBUG
xfs/503             61s
xfs/504             38s
xfs/505            [not run] man utility required, skipped this test
xfs/506            [not run] Scrub not supported
xfs/507            [not run] Require XFS built with CONFIG_XFS_DEBUG
xfs/508             2s
xfs/509             18s
xfs/510             1s
xfs/511             1s
xfs/512             1s
xfs/513             12s
xfs/514            [not run] man utility required, skipped this test
xfs/515            [not run] man utility required, skipped this test
xfs/516             33s
xfs/517            [not run] xfs_io scrub support is missing
xfs/518             2s
xfs/519             3s
xfs/520             2s
xfs/521            [not run] External volumes not in use, skipped this test
xfs/522             1s
xfs/523             1s
xfs/524             1s
xfs/525             1s
xfs/526            [not run] v4 file systems not supported
xfs/527            [not run] Require XFS built with CONFIG_XFS_DEBUG
xfs/528            [not run] External volumes not in use, skipped this test
xfs/529            [not run] Require XFS built with CONFIG_XFS_DEBUG
xfs/530            [not run] External volumes not in use, skipped this test
xfs/531            [not run] Require XFS built with CONFIG_XFS_DEBUG
xfs/532            [not run] Require XFS built with CONFIG_XFS_DEBUG
xfs/533             1s
xfs/534            [not run] Require XFS built with CONFIG_XFS_DEBUG
xfs/535            [not run] Require XFS built with CONFIG_XFS_DEBUG
xfs/536            [not run] Require XFS built with CONFIG_XFS_DEBUG
xfs/537            [not run] Require XFS built with CONFIG_XFS_DEBUG
xfs/538            [not run] Require XFS built with CONFIG_XFS_DEBUG
xfs/540             1s
xfs/541            [not run] External volumes not in use, skipped this test
xfs/542             2s
xfs/543             1s
xfs/544            [not run] xfsdump not found
xfs/545            [not run] xfsdump not found
xfs/546             1s
xfs/547            [not run] Require XFS built with CONFIG_XFS_DEBUG
xfs/548            [not run] Require XFS built with CONFIG_XFS_DEBUG
xfs/549             1s
xfs/550            [not run] /dev/sdb xfs does not support -o dax
xfs/551            [not run] /dev/sdb xfs does not support -o dax
xfs/552            [not run] /dev/sdb xfs does not support -o dax
xfs/553            [not run] Require XFS built with CONFIG_XFS_DEBUG
xfs/554            [not run] xfsdump not found
xfs/555             2s
xfs/556            [not run] Scrub not supported
xfs/557             5s
xfs/558            [not run] XFS error injection requires CONFIG_XFS_DEBUG
xfs/559            [not run] XFS error injection requires CONFIG_XFS_DEBUG
xfs/560            [not run] xfs_io scrub support is missing
xfs/565            [not run] xfs_io scrub support is missing
xfs/566            [not run] xfs_io scrub support is missing
xfs/567            [not run] xfsdump not found
xfs/568            [not run] xfsdump not found
xfs/596            [not run] External volumes not in use, skipped this test
xfs/597             2s
xfs/598             112s
xfs/599             3s
xfs/600             4s
xfs/601             44s
xfs/602             5s
xfs/603            [not run] xfs_io repair support is missing
xfs/604             12s
xfs/605            [not run] Require XFS built with CONFIG_XFS_DEBUG
xfs/606             1s
xfs/607            [not run] XFS error injection requires CONFIG_XFS_DEBUG
xfs/608            [not run] v4 file systems not supported
xfs/609             81s
xfs/610            [not run] External volumes not in use, skipped this test
xfs/612            [not run] v4 file systems not supported
xfs/613            [not run] v4 file systems not supported
xfs/614            [not run] mkfs does not support concurrency options
xfs/615            [not run] Require XFS built with CONFIG_XFS_DEBUG
xfs/616            [not run] xfs_io exchangerange  support is missing
xfs/617            [not run] xfs_io exchangerange  support is missing
xfs/618            [not run] sysfs attribute 'debug/larp' is not supported
xfs/619            [not run] sysfs attribute 'debug/larp' is not supported
xfs/620            [not run] sysfs attribute 'debug/larp' is not supported
xfs/623            [not run] xfs_io scrub support is missing
xfs/624            [not run] xfs_io scrub support is missing
xfs/625            [not run] xfs_io scrub support is missing
xfs/626            [not run] xfs_io scrub support is missing
xfs/627            [not run] xfs_io scrub support is missing
xfs/633            [not run] xfs_db rdump support is missing
xfs/634             2s
xfs/635            [not run] External volumes not in use, skipped this test
xfs/636            [not run] External volumes not in use, skipped this test
xfs/637            [not run] this test requires a zoned block device
xfs/638            [not run] Requires zoned file system
xfs/639            [not run] Requires zoned file system
xfs/640            [not run] kernel does not support asynchronous I/O
xfs/641            [not run] kernel does not support asynchronous I/O
xfs/642            [not run] kernel does not support asynchronous I/O
xfs/643            [not run] kernel does not support asynchronous I/O
xfs/644            [not run] kernel does not support asynchronous I/O
xfs/645             2s
xfs/646            [not run] Requires zoned file system
xfs/647            [not run] External volumes not in use, skipped this test
xfs/648            [not run] /home/azureuser/xfstests-dev/src/file_attr not=
 built
xfs/649             5s
xfs/650            [not run] External volumes not in use, skipped this test
xfs/651            [not run] Can't create zoned file system
xfs/652            [not run] External volumes not in use, skipped this test
xfs/653            [not run] cannot mkfs zoned filesystem
xfs/654            [not run] xfs_io healthmon -p support is missing
xfs/655            [not run] xfs_io healthmon -p support is missing
xfs/656            [not run] xfs_io healthmon -p support is missing
xfs/657            [not run] xfs_io scrub support is missing
xfs/658            [not run] xfs_io repair support is missing
xfs/659            [not run] xfs_healer utility required, skipped this test
xfs/660            [not run] xfs_healer utility required, skipped this test
xfs/661            [not run] xfs_healer utility required, skipped this test
xfs/662            [not run] xfs_io repair support is missing
xfs/663            [not run] xfs_io repair support is missing
xfs/664            [not run] xfs_io repair support is missing
xfs/665            [not run] systemd unit "xfs_healer@.service" not found
xfs/666            [not run] systemd unit "xfs_healer@.service" not found
xfs/667            [not run] xfs_io repair support is missing
xfs/668            [not run] this test requires a zoned block device
xfs/669            [not run] Zoned mkfs not supported
xfs/716            [not run] XFS error injection requires CONFIG_XFS_DEBUG
xfs/732            [not run] External volumes not in use, skipped this test
xfs/789             1s
xfs/790            [not run] xfs_io exchangerange  support is missing
xfs/791            [not run] xfs_io exchangerange  support is missing
xfs/792            [not run] xfs_io exchangerange  support is missing
xfs/798            [not run] xfs_io repair support is missing
xfs/802            [not run] systemd unit "xfs_scrub@.service" not found
xfs/803            [not run] xfs_io listfsprops  support is missing
xfs/804            [not run] xfs_property utility required, skipped this te=
st
xfs/805            [not run] xfs_io listfsprops  support is missing
xfs/806            [not run] xfs_io listfsprops  support is missing
xfs/817            [not run] xfs_io scrub support is missing
xfs/818            [not run] xfs_protofile utility required, skipped this t=
est
xfs/819            [not run] mkfs.xfs protofile does not support xattrs
xfs/820            [not run] mkfs does not support uquota option
xfs/821            [not run] realtime not supported by scratch filesystem t=
ype: xfs
xfs/837            [not run] External volumes not in use, skipped this test
xfs/838            [not run] External volumes not in use, skipped this test
xfs/839            [not run] xfs_io pwrite doesn't support -A
xfs/840            [not run] write atomic not supported by this block device
xfs/841            [not run] mkfs.xfs does not support -p option for direct=
ory population
Ran: generic/001 generic/002 generic/003 generic/004 generic/005 generic/00=
6 generic/007 generic/008 generic/009 generic/010 generic/011 generic/012 g=
eneric/013 generic/014 generic/015 generic/016 generic/017 generic/018 gene=
ric/020 generic/021 generic/022 generic/023 generic/024 generic/025 generic=
/026 generic/027 generic/028 generic/029 generic/030 generic/031 generic/03=
2 generic/033 generic/034 generic/035 generic/036 generic/037 generic/038 g=
eneric/039 generic/040 generic/041 generic/042 generic/043 generic/044 gene=
ric/045 generic/046 generic/047 generic/048 generic/049 generic/050 generic=
/051 generic/052 generic/053 generic/054 generic/055 generic/056 generic/05=
7 generic/058 generic/059 generic/060 generic/061 generic/062 generic/063 g=
eneric/064 generic/065 generic/066 generic/067 generic/068 generic/069 gene=
ric/070 generic/071 generic/072 generic/073 generic/074 generic/075 generic=
/076 generic/077 generic/078 generic/079 generic/080 generic/081 generic/08=
2 generic/083 generic/084 generic/085 generic/086 generic/087 generic/088 g=
eneric/089 generic/090 generic/091 generic/092 generic/093 generic/094 gene=
ric/095 generic/096 generic/097 generic/098 generic/099 generic/100 generic=
/101 generic/102 generic/103 generic/104 generic/105 generic/106 generic/10=
7 generic/108 generic/109 generic/110 generic/111 generic/112 generic/113 g=
eneric/114 generic/115 generic/116 generic/117 generic/118 generic/119 gene=
ric/120 generic/121 generic/122 generic/123 generic/124 generic/125 generic=
/126 generic/127 generic/128 generic/129 generic/130 generic/131 generic/13=
2 generic/133 generic/134 generic/135 generic/136 generic/137 generic/138 g=
eneric/139 generic/140 generic/141 generic/142 generic/143 generic/144 gene=
ric/145 generic/146 generic/147 generic/148 generic/149 generic/150 generic=
/151 generic/152 generic/153 generic/154 generic/155 generic/156 generic/15=
7 generic/158 generic/159 generic/160 generic/161 generic/162 generic/163 g=
eneric/164 generic/165 generic/166 generic/167 generic/168 generic/169 gene=
ric/170 generic/171 generic/172 generic/173 generic/174 generic/175 generic=
/176 generic/177 generic/178 generic/179 generic/180 generic/181 generic/18=
2 generic/183 generic/184 generic/185 generic/186 generic/187 generic/188 g=
eneric/189 generic/190 generic/191 generic/192 generic/193 generic/194 gene=
ric/195 generic/196 generic/197 generic/198 generic/199 generic/200 generic=
/201 generic/202 generic/203 generic/204 generic/205 generic/206 generic/20=
7 generic/208 generic/209 generic/210 generic/211 generic/212 generic/213 g=
eneric/214 generic/215 generic/216 generic/217 generic/218 generic/219 gene=
ric/220 generic/221 generic/222 generic/223 generic/224 generic/225 generic=
/226 generic/227 generic/228 generic/229 generic/230 generic/231 generic/23=
2 generic/233 generic/234 generic/235 generic/236 generic/237 generic/238 g=
eneric/239 generic/240 generic/241 generic/242 generic/243 generic/244 gene=
ric/245 generic/246 generic/247 generic/248 generic/249 generic/250 generic=
/251 generic/252 generic/253 generic/254 generic/255 generic/256 generic/25=
7 generic/258 generic/259 generic/260 generic/261 generic/262 generic/263 g=
eneric/264 generic/265 generic/266 generic/267 generic/268 generic/269 gene=
ric/270 generic/271 generic/272 generic/273 generic/274 generic/275 generic=
/276 generic/277 generic/278 generic/279 generic/280 generic/281 generic/28=
2 generic/283 generic/284 generic/285 generic/286 generic/287 generic/288 g=
eneric/289 generic/290 generic/291 generic/292 generic/293 generic/294 gene=
ric/295 generic/296 generic/297 generic/298 generic/299 generic/300 generic=
/301 generic/302 generic/303 generic/304 generic/305 generic/306 generic/30=
7 generic/308 generic/309 generic/310 generic/311 generic/312 generic/313 g=
eneric/314 generic/315 generic/316 generic/317 generic/318 generic/319 gene=
ric/320 generic/321 generic/322 generic/323 generic/324 generic/325 generic=
/326 generic/327 generic/328 generic/329 generic/330 generic/331 generic/33=
2 generic/333 generic/334 generic/335 generic/336 generic/337 generic/338 g=
eneric/339 generic/340 generic/341 generic/342 generic/343 generic/344 gene=
ric/345 generic/346 generic/347 generic/348 generic/352 generic/353 generic=
/354 generic/355 generic/356 generic/357 generic/358 generic/359 generic/36=
0 generic/361 generic/362 generic/363 generic/364 generic/365 generic/366 g=
eneric/368 generic/369 generic/370 generic/371 generic/372 generic/373 gene=
ric/374 generic/375 generic/376 generic/377 generic/378 generic/379 generic=
/380 generic/381 generic/382 generic/383 generic/384 generic/385 generic/38=
6 generic/387 generic/388 generic/389 generic/390 generic/391 generic/392 g=
eneric/393 generic/394 generic/395 generic/396 generic/397 generic/398 gene=
ric/399 generic/400 generic/401 generic/402 generic/403 generic/404 generic=
/405 generic/406 generic/407 generic/408 generic/409 generic/410 generic/41=
1 generic/412 generic/413 generic/414 generic/415 generic/416 generic/417 g=
eneric/418 generic/419 generic/420 generic/421 generic/422 generic/423 gene=
ric/424 generic/425 generic/426 generic/427 generic/428 generic/429 generic=
/430 generic/431 generic/432 generic/433 generic/434 generic/435 generic/43=
6 generic/437 generic/438 generic/439 generic/440 generic/441 generic/443 g=
eneric/444 generic/445 generic/446 generic/447 generic/448 generic/449 gene=
ric/450 generic/451 generic/452 generic/453 generic/454 generic/455 generic=
/456 generic/457 generic/458 generic/459 generic/460 generic/461 generic/46=
2 generic/463 generic/464 generic/465 generic/466 generic/467 generic/468 g=
eneric/469 generic/470 generic/471 generic/472 generic/474 generic/475 gene=
ric/476 generic/477 generic/478 generic/479 generic/480 generic/481 generic=
/482 generic/483 generic/484 generic/485 generic/486 generic/487 generic/48=
8 generic/489 generic/490 generic/491 generic/492 generic/493 generic/494 g=
eneric/495 generic/496 generic/497 generic/498 generic/499 generic/500 gene=
ric/501 generic/502 generic/503 generic/504 generic/505 generic/506 generic=
/507 generic/508 generic/509 generic/510 generic/511 generic/512 generic/51=
3 generic/514 generic/515 generic/516 generic/517 generic/518 generic/519 g=
eneric/520 generic/523 generic/524 generic/525 generic/526 generic/527 gene=
ric/528 generic/529 generic/530 generic/531 generic/532 generic/533 generic=
/534 generic/535 generic/536 generic/537 generic/538 generic/539 generic/54=
0 generic/541 generic/542 generic/543 generic/544 generic/545 generic/546 g=
eneric/547 generic/548 generic/549 generic/550 generic/551 generic/552 gene=
ric/553 generic/554 generic/555 generic/556 generic/557 generic/558 generic=
/559 generic/560 generic/561 generic/562 generic/563 generic/564 generic/56=
5 generic/566 generic/567 generic/568 generic/569 generic/570 generic/571 g=
eneric/572 generic/573 generic/574 generic/575 generic/576 generic/577 gene=
ric/578 generic/579 generic/580 generic/581 generic/582 generic/583 generic=
/584 generic/585 generic/586 generic/587 generic/588 generic/589 generic/59=
0 generic/591 generic/592 generic/593 generic/594 generic/595 generic/596 g=
eneric/597 generic/598 generic/599 generic/600 generic/601 generic/602 gene=
ric/603 generic/604 generic/605 generic/606 generic/607 generic/608 generic=
/609 generic/610 generic/611 generic/612 generic/613 generic/614 generic/61=
5 generic/616 generic/617 generic/618 generic/619 generic/620 generic/621 g=
eneric/622 generic/623 generic/624 generic/625 generic/626 generic/627 gene=
ric/628 generic/629 generic/630 generic/631 generic/632 generic/633 generic=
/634 generic/635 generic/636 generic/637 generic/638 generic/639 generic/64=
0 generic/641 generic/642 generic/643 generic/644 generic/645 generic/646 g=
eneric/647 generic/648 generic/649 generic/650 generic/651 generic/652 gene=
ric/653 generic/654 generic/655 generic/656 generic/657 generic/658 generic=
/659 generic/660 generic/661 generic/662 generic/663 generic/664 generic/66=
5 generic/666 generic/667 generic/668 generic/669 generic/670 generic/671 g=
eneric/672 generic/673 generic/674 generic/675 generic/676 generic/677 gene=
ric/678 generic/679 generic/680 generic/681 generic/682 generic/683 generic=
/684 generic/685 generic/686 generic/687 generic/688 generic/689 generic/69=
0 generic/691 generic/692 generic/693 generic/694 generic/695 generic/696 g=
eneric/697 generic/698 generic/699 generic/700 generic/701 generic/702 gene=
ric/703 generic/704 generic/705 generic/706 generic/707 generic/708 generic=
/709 generic/710 generic/711 generic/712 generic/713 generic/714 generic/71=
5 generic/716 generic/717 generic/718 generic/719 generic/720 generic/721 g=
eneric/722 generic/723 generic/724 generic/725 generic/726 generic/727 gene=
ric/728 generic/729 generic/730 generic/731 generic/732 generic/733 generic=
/734 generic/735 generic/736 generic/737 generic/738 generic/739 generic/74=
0 generic/741 generic/742 generic/743 generic/744 generic/745 generic/746 g=
eneric/747 generic/748 generic/749 generic/750 generic/751 generic/752 gene=
ric/753 generic/754 generic/755 generic/756 generic/757 generic/758 generic=
/759 generic/760 generic/761 generic/762 generic/763 generic/764 generic/76=
5 generic/766 generic/767 generic/768 generic/769 generic/770 generic/771 g=
eneric/772 generic/773 generic/774 generic/775 generic/776 generic/777 gene=
ric/778 generic/779 generic/781 generic/782 generic/783 generic/784 generic=
/785 generic/786 generic/787 generic/788 generic/789 generic/790 generic/79=
1 generic/792 generic/793 generic/794 xfs/001 xfs/002 xfs/003 xfs/004 xfs/0=
05 xfs/006 xfs/007 xfs/008 xfs/009 xfs/010 xfs/011 xfs/012 xfs/013 xfs/014 =
xfs/015 xfs/016 xfs/017 xfs/018 xfs/019 xfs/020 xfs/021 xfs/026 xfs/027 xfs=
/028 xfs/029 xfs/030 xfs/031 xfs/032 xfs/033 xfs/034 xfs/035 xfs/040 xfs/04=
1 xfs/042 xfs/044 xfs/045 xfs/046 xfs/047 xfs/048 xfs/049 xfs/050 xfs/051 x=
fs/052 xfs/053 xfs/054 xfs/056 xfs/057 xfs/058 xfs/059 xfs/060 xfs/061 xfs/=
062 xfs/063 xfs/064 xfs/065 xfs/066 xfs/067 xfs/068 xfs/069 xfs/070 xfs/071=
 xfs/072 xfs/073 xfs/074 xfs/075 xfs/076 xfs/077 xfs/078 xfs/079 xfs/080 xf=
s/081 xfs/082 xfs/084 xfs/090 xfs/092 xfs/094 xfs/095 xfs/096 xfs/103 xfs/1=
04 xfs/106 xfs/107 xfs/108 xfs/109 xfs/110 xfs/114 xfs/115 xfs/116 xfs/118 =
xfs/119 xfs/121 xfs/122 xfs/127 xfs/128 xfs/129 xfs/131 xfs/132 xfs/135 xfs=
/137 xfs/138 xfs/139 xfs/140 xfs/141 xfs/142 xfs/143 xfs/144 xfs/145 xfs/14=
6 xfs/147 xfs/148 xfs/149 xfs/150 xfs/151 xfs/152 xfs/153 xfs/154 xfs/155 x=
fs/156 xfs/157 xfs/158 xfs/159 xfs/160 xfs/161 xfs/162 xfs/163 xfs/164 xfs/=
165 xfs/166 xfs/167 xfs/168 xfs/169 xfs/170 xfs/174 xfs/175 xfs/176 xfs/177=
 xfs/178 xfs/179 xfs/180 xfs/181 xfs/182 xfs/183 xfs/184 xfs/185 xfs/186 xf=
s/187 xfs/188 xfs/189 xfs/190 xfs/191 xfs/192 xfs/193 xfs/194 xfs/195 xfs/1=
96 xfs/197 xfs/198 xfs/199 xfs/200 xfs/201 xfs/202 xfs/203 xfs/204 xfs/205 =
xfs/206 xfs/207 xfs/208 xfs/209 xfs/210 xfs/212 xfs/213 xfs/214 xfs/215 xfs=
/216 xfs/217 xfs/218 xfs/219 xfs/220 xfs/221 xfs/222 xfs/223 xfs/224 xfs/22=
5 xfs/226 xfs/227 xfs/228 xfs/229 xfs/230 xfs/231 xfs/232 xfs/233 xfs/234 x=
fs/235 xfs/236 xfs/237 xfs/238 xfs/239 xfs/240 xfs/241 xfs/242 xfs/243 xfs/=
244 xfs/245 xfs/246 xfs/247 xfs/248 xfs/249 xfs/250 xfs/251 xfs/252 xfs/253=
 xfs/254 xfs/255 xfs/256 xfs/257 xfs/258 xfs/259 xfs/260 xfs/261 xfs/263 xf=
s/264 xfs/265 xfs/266 xfs/269 xfs/270 xfs/271 xfs/272 xfs/273 xfs/274 xfs/2=
75 xfs/276 xfs/277 xfs/278 xfs/279 xfs/280 xfs/281 xfs/282 xfs/283 xfs/284 =
xfs/285 xfs/286 xfs/287 xfs/288 xfs/289 xfs/290 xfs/291 xfs/292 xfs/293 xfs=
/294 xfs/295 xfs/296 xfs/297 xfs/298 xfs/299 xfs/300 xfs/301 xfs/302 xfs/30=
3 xfs/304 xfs/305 xfs/306 xfs/307 xfs/308 xfs/309 xfs/310 xfs/311 xfs/312 x=
fs/313 xfs/314 xfs/315 xfs/316 xfs/317 xfs/318 xfs/319 xfs/320 xfs/321 xfs/=
322 xfs/323 xfs/324 xfs/325 xfs/326 xfs/327 xfs/328 xfs/329 xfs/330 xfs/331=
 xfs/332 xfs/334 xfs/335 xfs/336 xfs/338 xfs/339 xfs/340 xfs/341 xfs/342 xf=
s/343 xfs/344 xfs/345 xfs/346 xfs/347 xfs/348 xfs/349 xfs/419 xfs/420 xfs/4=
21 xfs/424 xfs/431 xfs/432 xfs/433 xfs/434 xfs/435 xfs/436 xfs/437 xfs/438 =
xfs/439 xfs/440 xfs/441 xfs/442 xfs/443 xfs/444 xfs/445 xfs/446 xfs/447 xfs=
/448 xfs/449 xfs/450 xfs/451 xfs/452 xfs/490 xfs/491 xfs/492 xfs/493 xfs/49=
4 xfs/495 xfs/499 xfs/500 xfs/501 xfs/502 xfs/503 xfs/504 xfs/505 xfs/506 x=
fs/507 xfs/508 xfs/509 xfs/510 xfs/511 xfs/512 xfs/513 xfs/514 xfs/515 xfs/=
516 xfs/517 xfs/518 xfs/519 xfs/520 xfs/521 xfs/522 xfs/523 xfs/524 xfs/525=
 xfs/526 xfs/527 xfs/528 xfs/529 xfs/530 xfs/531 xfs/532 xfs/533 xfs/534 xf=
s/535 xfs/536 xfs/537 xfs/538 xfs/540 xfs/541 xfs/542 xfs/543 xfs/544 xfs/5=
45 xfs/546 xfs/547 xfs/548 xfs/549 xfs/550 xfs/551 xfs/552 xfs/553 xfs/554 =
xfs/555 xfs/556 xfs/557 xfs/558 xfs/559 xfs/560 xfs/565 xfs/566 xfs/567 xfs=
/568 xfs/596 xfs/597 xfs/598 xfs/599 xfs/600 xfs/601 xfs/602 xfs/603 xfs/60=
4 xfs/605 xfs/606 xfs/607 xfs/608 xfs/609 xfs/610 xfs/612 xfs/613 xfs/614 x=
fs/615 xfs/616 xfs/617 xfs/618 xfs/619 xfs/620 xfs/623 xfs/624 xfs/625 xfs/=
626 xfs/627 xfs/633 xfs/634 xfs/635 xfs/636 xfs/637 xfs/638 xfs/639 xfs/640=
 xfs/641 xfs/642 xfs/643 xfs/644 xfs/645 xfs/646 xfs/647 xfs/648 xfs/649 xf=
s/650 xfs/651 xfs/652 xfs/653 xfs/654 xfs/655 xfs/656 xfs/657 xfs/658 xfs/6=
59 xfs/660 xfs/661 xfs/662 xfs/663 xfs/664 xfs/665 xfs/666 xfs/667 xfs/668 =
xfs/669 xfs/716 xfs/732 xfs/789 xfs/790 xfs/791 xfs/792 xfs/798 xfs/802 xfs=
/803 xfs/804 xfs/805 xfs/806 xfs/817 xfs/818 xfs/819 xfs/820 xfs/821 xfs/83=
7 xfs/838 xfs/839 xfs/840 xfs/841
Not run: generic/010 generic/036 generic/095 generic/112 generic/113 generi=
c/114 generic/198 generic/207 generic/208 generic/209 generic/210 generic/2=
12 generic/239 generic/240 generic/241 generic/252 generic/299 generic/300 =
generic/323 generic/329 generic/330 generic/331 generic/332 generic/366 gen=
eric/368 generic/369 generic/395 generic/396 generic/397 generic/398 generi=
c/399 generic/413 generic/419 generic/421 generic/427 generic/429 generic/4=
35 generic/440 generic/451 generic/455 generic/457 generic/459 generic/462 =
generic/463 generic/465 generic/470 generic/482 generic/487 generic/538 gen=
eric/548 generic/549 generic/550 generic/551 generic/556 generic/559 generi=
c/560 generic/561 generic/565 generic/570 generic/572 generic/573 generic/5=
74 generic/575 generic/576 generic/577 generic/579 generic/580 generic/581 =
generic/582 generic/583 generic/584 generic/586 generic/592 generic/593 gen=
eric/595 generic/596 generic/602 generic/605 generic/606 generic/608 generi=
c/613 generic/616 generic/617 generic/621 generic/624 generic/625 generic/6=
27 generic/678 generic/679 generic/692 generic/693 generic/700 generic/703 =
generic/709 generic/710 generic/712 generic/713 generic/714 generic/715 gen=
eric/716 generic/717 generic/718 generic/719 generic/720 generic/721 generi=
c/722 generic/723 generic/724 generic/725 generic/726 generic/727 generic/7=
37 generic/739 generic/743 generic/744 generic/752 generic/756 generic/757 =
generic/765 generic/766 generic/767 generic/768 generic/769 generic/770 gen=
eric/772 generic/773 generic/774 generic/775 generic/776 generic/777 generi=
c/778 generic/781 generic/783 generic/786 generic/787 generic/788 generic/7=
91 generic/793 xfs/002 xfs/016 xfs/018 xfs/026 xfs/027 xfs/028 xfs/035 xfs/=
040 xfs/044 xfs/046 xfs/047 xfs/051 xfs/056 xfs/057 xfs/059 xfs/060 xfs/061=
 xfs/063 xfs/064 xfs/065 xfs/066 xfs/068 xfs/090 xfs/094 xfs/095 xfs/096 xf=
s/107 xfs/122 xfs/131 xfs/132 xfs/141 xfs/142 xfs/143 xfs/146 xfs/147 xfs/1=
48 xfs/186 xfs/187 xfs/189 xfs/194 xfs/195 xfs/196 xfs/197 xfs/199 xfs/237 =
xfs/239 xfs/240 xfs/241 xfs/243 xfs/244 xfs/245 xfs/246 xfs/266 xfs/275 xfs=
/276 xfs/281 xfs/282 xfs/283 xfs/285 xfs/286 xfs/287 xfs/293 xfs/296 xfs/30=
0 xfs/301 xfs/302 xfs/312 xfs/313 xfs/314 xfs/315 xfs/316 xfs/317 xfs/318 x=
fs/319 xfs/320 xfs/321 xfs/322 xfs/323 xfs/324 xfs/325 xfs/326 xfs/329 xfs/=
334 xfs/335 xfs/336 xfs/338 xfs/339 xfs/340 xfs/341 xfs/342 xfs/343 xfs/349=
 xfs/419 xfs/433 xfs/434 xfs/436 xfs/437 xfs/443 xfs/446 xfs/447 xfs/448 xf=
s/490 xfs/501 xfs/502 xfs/505 xfs/506 xfs/507 xfs/514 xfs/515 xfs/517 xfs/5=
21 xfs/526 xfs/527 xfs/528 xfs/529 xfs/530 xfs/531 xfs/532 xfs/534 xfs/535 =
xfs/536 xfs/537 xfs/538 xfs/541 xfs/544 xfs/545 xfs/547 xfs/548 xfs/550 xfs=
/551 xfs/552 xfs/553 xfs/554 xfs/556 xfs/558 xfs/559 xfs/560 xfs/565 xfs/56=
6 xfs/567 xfs/568 xfs/596 xfs/603 xfs/605 xfs/607 xfs/608 xfs/610 xfs/612 x=
fs/613 xfs/614 xfs/615 xfs/616 xfs/617 xfs/618 xfs/619 xfs/620 xfs/623 xfs/=
624 xfs/625 xfs/626 xfs/627 xfs/633 xfs/635 xfs/636 xfs/637 xfs/638 xfs/639=
 xfs/640 xfs/641 xfs/642 xfs/643 xfs/644 xfs/646 xfs/647 xfs/648 xfs/650 xf=
s/651 xfs/652 xfs/653 xfs/654 xfs/655 xfs/656 xfs/657 xfs/658 xfs/659 xfs/6=
60 xfs/661 xfs/662 xfs/663 xfs/664 xfs/665 xfs/666 xfs/667 xfs/668 xfs/669 =
xfs/716 xfs/732 xfs/790 xfs/791 xfs/792 xfs/798 xfs/802 xfs/803 xfs/804 xfs=
/805 xfs/806 xfs/817 xfs/818 xfs/819 xfs/820 xfs/821 xfs/837 xfs/838 xfs/83=
9 xfs/840 xfs/841
Failures: generic/062 generic/363 generic/365 generic/645 generic/753 gener=
ic/754 generic/794 xfs/273 xfs/299
Failed 9 of 1271 tests


--KFt0mAB3puHSe9pa--
