Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0FB847F55
	for <xfs@oss.sgi.com>; Thu, 15 Aug 2013 12:04:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8383EAC003
	for <xfs@oss.sgi.com>; Thu, 15 Aug 2013 10:04:49 -0700 (PDT)
Received: from mx1.vr-web.de (mx0.vr-web.de [195.200.35.198]) by cuda.sgi.com
	with ESMTP id kHHxEq0a0jfhi8Wj for <xfs@oss.sgi.com>;
	Thu, 15 Aug 2013 10:04:46 -0700 (PDT)
Message-ID: <520D0A15.1050304@allmail.net>
Date: Thu, 15 Aug 2013 19:04:21 +0200
From: Michael Maier <m1278468@allmail.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_repair: zero out unused parts of superblocks
References: <520C3C60.3090500@redhat.com>
In-Reply-To: <520C3C60.3090500@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

Eric Sandeen wrote:
> Prior to:
> 1375cb65 xfs: growfs: don't read garbage for new secondary superblocks
> =

> we ran the risk of allowing garbage in secondary superblocks
> beyond the in-use sb fields.  With kernels 3.10 and beyond, the
> verifiers will kick these out as invalid, but xfs_repair does
> not detect or repair this condition.
> =

> There is superblock stale-data zeroing code, but it is under a
> narrow conditional - the bug addressed in the above commit did not
> meet that conditional.  So change this to check unconditionally.
> =

> Further, the checking code was looking at the in-memory
> superblock buffer, which was zeroed prior to population, and
> would therefore never possibly show any stale data beyond the
> last up-rev superblock field.
> =

> So instead, check the disk buffer for this garbage condition.
> =

> If we detect garbage, we must zero out both the in-memory sb
> and the disk buffer; the former may contain unused data
> in up-rev sb fields which will be written back out; the latter
> may contain garbage beyond all fields, which won't be updated
> when we translate the in-memory sb back to disk.
> =

> The V4 superblock case was zeroing out the sb_bad_features2
> field; we also fix that to leave that field alone.
> =

> Lastly, use offsetof() instead of the tortured (__psint_t)
> casts & pointer math.
> =

> Reported-by: Michael Maier <m1278468@allmail.net>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> =

> Michael - this will need slight tweaking to apply against
> older xfsprogs.
> =

> Also:
> =

> With more of Dave's changes, I think we can swap out:
> =

> 		size =3D offsetof(xfs_sb_t, sb_lsn)
> 			+ sizeof(sb->sb_lsn);
> for
> 		size =3D xfs_sb_info[XFS_SBS_LSN + 1].offset;
> =

> but this version is a bit easier to backport, and works in the
> current git tree...

I tested with current git tree and it worked as expected for me!
Afterwards I was able to run xfs_growfs (from 3.1.11) w/o any problem.

Please excuse me - forgot to set the english locale before starting.
Hope you can guess what it should be in english :-).


Phase 1 - Superblock finden und =FCberpr=FCfen...
Schreiben ver=E4ndert prim=E4ren Superblock
Phase 2 - ein internes Protokoll benutzen
        - Null-Protokoll...
        - freier Speicher und Inode-Karten des Dateisystems werden
gescannt...
ungenutzten Anteil des =BBprim=E4r=AB-Superblocks nullen (AG #0)
prim=E4re/sekund=E4rer Superblock-1-Konflikt - AG-Superblock-Geometrie-Info
hat einen Konflikt mit der
Dateisystem-Geometrie
falscher sb f=FCr ag 1 wird zur=FCckgesetzt
prim=E4re/sekund=E4rer Superblock-2-Konflikt - AG-Superblock-Geometrie-Info
hat einen Konflikt mit der
Dateisystem-Geometrie
falscher sb f=FCr ag 2 wird zur=FCckgesetzt
prim=E4re/sekund=E4rer Superblock-3-Konflikt - AG-Superblock-Geometrie-Info
hat einen Konflikt mit der
Dateisystem-Geometrie
falscher sb f=FCr ag 3 wird zur=FCckgesetzt
prim=E4re/sekund=E4rer Superblock-4-Konflikt - AG-Superblock-Geometrie-Info
hat einen Konflikt mit der
Dateisystem-Geometrie
falscher sb f=FCr ag 4 wird zur=FCckgesetzt
prim=E4re/sekund=E4rer Superblock-5-Konflikt - AG-Superblock-Geometrie-Info
hat einen Konflikt mit der
Dateisystem-Geometrie
falscher sb f=FCr ag 5 wird zur=FCckgesetzt
prim=E4re/sekund=E4rer Superblock-6-Konflikt - AG-Superblock-Geometrie-Info
hat einen Konflikt mit der
Dateisystem-Geometrie
falscher sb f=FCr ag 6 wird zur=FCckgesetzt
prim=E4re/sekund=E4rer Superblock-7-Konflikt - AG-Superblock-Geometrie-Info
hat einen Konflikt mit der
Dateisystem-Geometrie
falscher sb f=FCr ag 7 wird zur=FCckgesetzt
prim=E4re/sekund=E4rer Superblock-8-Konflikt - AG-Superblock-Geometrie-Info
hat einen Konflikt mit der
Dateisystem-Geometrie
falscher sb f=FCr ag 8 wird zur=FCckgesetzt
prim=E4re/sekund=E4rer Superblock-9-Konflikt - AG-Superblock-Geometrie-Info
hat einen Konflikt mit der
Dateisystem-Geometrie
falscher sb f=FCr ag 9 wird zur=FCckgesetzt
prim=E4re/sekund=E4rer Superblock-10-Konflikt - AG-Superblock-Geometrie-Info
hat einen Konflikt mit der
Dateisystem-Geometrie
falscher sb f=FCr ag 10 wird zur=FCckgesetzt
prim=E4re/sekund=E4rer Superblock-11-Konflikt - AG-Superblock-Geometrie-Info
hat einen Konflikt mit der
Dateisystem-Geometrie
falscher sb f=FCr ag 11 wird zur=FCckgesetzt
prim=E4re/sekund=E4rer Superblock-12-Konflikt - AG-Superblock-Geometrie-Info
hat einen Konflikt mit der
Dateisystem-Geometrie
falscher sb f=FCr ag 12 wird zur=FCckgesetzt
prim=E4re/sekund=E4rer Superblock-13-Konflikt - AG-Superblock-Geometrie-Info
hat einen Konflikt mit der
Dateisystem-Geometrie
falscher sb f=FCr ag 13 wird zur=FCckgesetzt
prim=E4re/sekund=E4rer Superblock-14-Konflikt - AG-Superblock-Geometrie-Info
hat einen Konflikt mit der
Dateisystem-Geometrie
falscher sb f=FCr ag 14 wird zur=FCckgesetzt
prim=E4re/sekund=E4rer Superblock-15-Konflikt - AG-Superblock-Geometrie-Info
hat einen Konflikt mit der
Dateisystem-Geometrie
falscher sb f=FCr ag 15 wird zur=FCckgesetzt
xfs_sb_read_verify: XFS_CORRUPTION_ERROR
ungenutzten Anteil des =BBsekund=E4r=AB-Superblocks nullen (AG #16)
xfs_sb_read_verify: XFS_CORRUPTION_ERROR
ungenutzten Anteil des =BBsekund=E4r=AB-Superblocks nullen (AG #17)
xfs_sb_read_verify: XFS_CORRUPTION_ERROR
ungenutzten Anteil des =BBsekund=E4r=AB-Superblocks nullen (AG #18)
xfs_sb_read_verify: XFS_CORRUPTION_ERROR
ungenutzten Anteil des =BBsekund=E4r=AB-Superblocks nullen (AG #19)
xfs_sb_read_verify: XFS_CORRUPTION_ERROR
ungenutzten Anteil des =BBsekund=E4r=AB-Superblocks nullen (AG #20)
xfs_sb_read_verify: XFS_CORRUPTION_ERROR
ungenutzten Anteil des =BBsekund=E4r=AB-Superblocks nullen (AG #21)
xfs_sb_read_verify: XFS_CORRUPTION_ERROR
ungenutzten Anteil des =BBsekund=E4r=AB-Superblocks nullen (AG #22)
xfs_sb_read_verify: XFS_CORRUPTION_ERROR
ungenutzten Anteil des =BBsekund=E4r=AB-Superblocks nullen (AG #23)
xfs_sb_read_verify: XFS_CORRUPTION_ERROR
ungenutzten Anteil des =BBsekund=E4r=AB-Superblocks nullen (AG #24)
xfs_sb_read_verify: XFS_CORRUPTION_ERROR
ungenutzten Anteil des =BBsekund=E4r=AB-Superblocks nullen (AG #25)
xfs_sb_read_verify: XFS_CORRUPTION_ERROR
ungenutzten Anteil des =BBsekund=E4r=AB-Superblocks nullen (AG #26)
xfs_sb_read_verify: XFS_CORRUPTION_ERROR
ungenutzten Anteil des =BBsekund=E4r=AB-Superblocks nullen (AG #27)
xfs_sb_read_verify: XFS_CORRUPTION_ERROR
ungenutzten Anteil des =BBsekund=E4r=AB-Superblocks nullen (AG #28)
xfs_sb_read_verify: XFS_CORRUPTION_ERROR
ungenutzten Anteil des =BBsekund=E4r=AB-Superblocks nullen (AG #29)
invalid start block 4096000 in record 1 of bno btree block 41/1
invalid start block 4096000 in record 1 of cnt btree block 41/2
agf_freeblks 3604481, gez=E4hlt 1 in ag 41
agf_longest 3604480, gez=E4hlt 1 in ag 41
sb_icount 0, counted 6528
sb_ifree 0, counted 669
sb_fdblocks 0, counted 80515
        - Wurzel-Inode-St=FCck gefunden
Phase 3 - f=FCr jedes AG...
        - agi unverkn=FCpfte Listen werden gescannt und bereinigt...
        - bekannte Inodes werden behandelt und Inode-Entdeckung wird
durchgef=FChrt...
        - agno =3D 0
        - agno =3D 1
        - agno =3D 2
        - agno =3D 3
        - agno =3D 4
        - agno =3D 5
        - agno =3D 6
        - agno =3D 7
        - agno =3D 8
        - agno =3D 9
        - agno =3D 10
        - agno =3D 11
        - agno =3D 12
        - agno =3D 13
        - agno =3D 14
        - agno =3D 15
        - agno =3D 16
        - agno =3D 17
        - agno =3D 18
        - agno =3D 19
        - agno =3D 20
        - agno =3D 21
        - agno =3D 22
        - agno =3D 23
        - agno =3D 24
        - agno =3D 25
        - agno =3D 26
        - agno =3D 27
        - agno =3D 28
        - agno =3D 29
        - agno =3D 30
        - agno =3D 31
        - agno =3D 32
        - agno =3D 33
        - agno =3D 34
        - agno =3D 35
        - agno =3D 36
        - agno =3D 37
        - agno =3D 38
        - agno =3D 39
        - agno =3D 40
        - agno =3D 41
        - neu entdeckte Inodes werden behandelt...
Phase 4 - auf doppelte Bl=F6cke =FCberpr=FCfen...
        - Liste mit doppeltem Ausma=DF wird eingerichtet...
        - es wird gepr=FCft ob Inodes Blocks doppelt beanspruchen...
        - agno =3D 0
        - agno =3D 2
        - agno =3D 1
        - agno =3D 4
        - agno =3D 3
        - agno =3D 6
        - agno =3D 7
        - agno =3D 5
        - agno =3D 8
        - agno =3D 9
        - agno =3D 10
        - agno =3D 11
        - agno =3D 12
        - agno =3D 13
        - agno =3D 14
        - agno =3D 15
        - agno =3D 16
        - agno =3D 17
        - agno =3D 18
        - agno =3D 19
        - agno =3D 20
        - agno =3D 21
        - agno =3D 22
        - agno =3D 23
        - agno =3D 24
        - agno =3D 25
        - agno =3D 26
        - agno =3D 27
        - agno =3D 29
        - agno =3D 30
        - agno =3D 28
        - agno =3D 31
        - agno =3D 33
        - agno =3D 32
        - agno =3D 34
        - agno =3D 35
        - agno =3D 36
        - agno =3D 38
        - agno =3D 37
        - agno =3D 40
        - agno =3D 39
        - agno =3D 41
Phase 5 - AG-K=F6pfe und B=E4ume werden erneut gebildet...
        - Superblock wird zur=FCckgesetzt...
Phase 6 - Inode-Verbindbarkeit wird gepr=FCft...
        - Inhalte der Echtzeit-Bitmaps und Zusammenfassungs-Inodes
werden zur=FCckgesetzt
        - Dateisystem wird durchquert ...
        - durchqueren beendet ...
        - nicht verbundene Inodes werden nach lost+found verschoben ...
Phase 7 - Verweisanzahl wird gepr=FCft und berichtigt...
erledigt


Thanks,
kind regards,
Michael

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
