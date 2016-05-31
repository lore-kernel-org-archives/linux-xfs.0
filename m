Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 64B147CA2
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 05:55:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 23B3830404E
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 03:55:30 -0700 (PDT)
Received: from mx.recia.fr (mx.recia.fr [95.128.41.47]) by cuda.sgi.com with
	ESMTP id 5GoE8Sihi506IISX (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 31 May 2016 03:55:25 -0700 (PDT)
Received: from e6530-damien.recia.fr (unknown [37.58.188.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested) (Authenticated sender: F12A086p)
	by mx.recia.fr (Postfix) with ESMTPSA id 4FF6A22630D
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 12:55:22 +0200 (CEST)
From: Damien Gombault <damien.gombault@recia.fr>
Subject: Cumulative xfsrestore shows many warnings and files/directories are
	missing after restoration
Message-ID: <8323ac3a-f9d2-ad31-69e3-1eea5a44dcde@recia.fr>
Date: Tue, 31 May 2016 12:55:22 +0200
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3379999186296809403=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--===============3379999186296809403==
Content-Type: multipart/alternative;
 boundary="------------A21625E3864E2E4E4F99257C"

This is a multi-part message in MIME format.
--------------A21625E3864E2E4E4F99257C
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi.

I use xfsdump to backup my systems.
Recently I had to use xfsrestore to restore a cumulative level 0 + level 1 dumps.

The level 0 dump log is :
/usr/sbin/xfsdump: using file dump (drive_simple) strategy
/usr/sbin/xfsdump: version 3.1.4 (dump format 3.0)
/usr/sbin/xfsdump: level 0 dump of owncloud:/
/usr/sbin/xfsdump: dump date: Sat May  7 02:10:04 2016
/usr/sbin/xfsdump: session id: 6ca00754-b885-4d2f-8785-e0399961c765
/usr/sbin/xfsdump: session label: "machine:owncloud partition:/ level:0 date:2016-05-07-02-10"
/usr/sbin/xfsdump: ino map phase 1: constructing initial dump list
/usr/sbin/xfsdump: ino map phase 2: skipping (no pruning necessary)
/usr/sbin/xfsdump: ino map phase 3: skipping (only one dump stream)
/usr/sbin/xfsdump: ino map construction complete
/usr/sbin/xfsdump: estimated dump size: 216034001408 bytes
/usr/sbin/xfsdump: creating dump session media file 0 (media 0, file 0)
/usr/sbin/xfsdump: dumping ino map
/usr/sbin/xfsdump: dumping directories
/usr/sbin/xfsdump: dumping non-directory files
/usr/sbin/xfsdump: ending media file
/usr/sbin/xfsdump: media file size 215829487392 bytes
/usr/sbin/xfsdump: dump size (non-dir files) : 215703283288 bytes
/usr/sbin/xfsdump: dump complete: 6199 seconds elapsed
/usr/sbin/xfsdump: Dump Summary:
/usr/sbin/xfsdump:   stream 0 /mnt/backup/xfsdump/owncloud-+-L0-2016-05-07-02-10.dump OK (success)
/usr/sbin/xfsdump: Dump Status: SUCCESS

The level 1 dump log is :
/usr/sbin/xfsdump: using file dump (drive_simple) strategy
/usr/sbin/xfsdump: version 3.1.4 (dump format 3.0)
/usr/sbin/xfsdump: level 1 incremental dump of owncloud:/ based on level 0 dump begun Sat May  7 02:10:04 2016
/usr/sbin/xfsdump: dump date: Sun May 29 02:10:04 2016
/usr/sbin/xfsdump: session id: 8693d7f5-395a-41c4-bb8c-dbbaa7dc7a57
/usr/sbin/xfsdump: session label: "machine:owncloud partition:/ level:1 date:2016-05-29-02-10"
/usr/sbin/xfsdump: ino map phase 1: constructing initial dump list
/usr/sbin/xfsdump: ino map phase 2: pruning unneeded subtrees
/usr/sbin/xfsdump: ino map phase 3: skipping (only one dump stream)
/usr/sbin/xfsdump: ino map construction complete
/usr/sbin/xfsdump: estimated dump size: 38360233792 bytes
/usr/sbin/xfsdump: creating dump session media file 0 (media 0, file 0)
/usr/sbin/xfsdump: dumping ino map
/usr/sbin/xfsdump: dumping directories
/usr/sbin/xfsdump: dumping non-directory files
/usr/sbin/xfsdump: ending media file
/usr/sbin/xfsdump: media file size 38266860896 bytes
/usr/sbin/xfsdump: dump size (non-dir files) : 38240915448 bytes
/usr/sbin/xfsdump: dump complete: 10506 seconds elapsed
/usr/sbin/xfsdump: Dump Summary:
/usr/sbin/xfsdump:   stream 0 /mnt/backup/xfsdump/owncloud-+-L1-2016-05-29-02-10.dump OK (success)
/usr/sbin/xfsdump: Dump Status: SUCCESS

The 2 dumps seems OK.

I created a new XFS file system.
I restored the level 0 dump on it with option -r (cumulative mode).
Then I restored the level 1 dump on it with the same options.

The level 0 restore is OK :
xfsrestore: drive 1: searching media for dump
xfsrestore: drive 0: searching media for directory dump
xfsrestore: drive 1: examining media file 0
xfsrestore: drive 1: searching media for directory dump
xfsrestore: drive 1: inventory session uuid (6ca00754-b885-4d2f-8785-e0399961c765) does not match the media header's session uuid (8693d7f5-395a-41c4-bb8c-dbbaa7dc7a57)
xfsrestore: drive 0: reading directories
xfsrestore: drive 0: 53796 directories and 370906 entries processed
xfsrestore: drive 0: directory post-processing
xfsrestore: drive 0: restoring non-directory files
xfsrestore: drive 0: NOTE: ino 51480542 gen 1438712790 not referenced: placing in orphanage
xfsrestore: drive 0: NOTE: ino 51480551 gen 1438712713 not referenced: placing in orphanage
xfsrestore: drive 0: WARNING: unable to rmdir /mnt/restore//orphanage: Le dossier n'est pas vide
xfsrestore: restore complete: 2764 seconds elapsed
xfsrestore: Restore Summary:
xfsrestore:   stream 0 /mnt/backup-owncloud/xfsdump/owncloud-+-L0-2016-05-07-02-10.dump OK (success)
xfsrestore:   stream 1 /mnt/backup-owncloud/xfsdump/owncloud-+-L1-2016-05-29-02-10.dump OK (success)
xfsrestore: Restore Status: SUCCESS

The 2 ino referenced is empty files, I suppose it was some empty PHP session files deleted during dump.

The level 1 restore shows many warnings :
xfsrestore: drive 0: examining media file 0
xfsrestore: drive 1: searching media for directory dump
xfsrestore: drive 1: reading directories
xfsrestore: drive 1: 11013 directories and 96122 entries processed
xfsrestore: drive 1: directory post-processing
xfsrestore: drive 1: WARNING: unable to rename dir orphanage/1677721775.4173752252 to dir var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/08 Sécurité/08c Gestion des mots de passe - Keepass: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: unable to rename dir orphanage/1711276202.4274102453 to dir var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/02 Mise en oeuvre sOlære: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: unable to rename dir orphanage/1694499004.2655526171 to dir var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/07 Communication: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: unable to rename dir orphanage/2365644069.2895542759 to dir var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/08 Sécurité/08c Gestion des mots de passe - Keepass: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: unable to rename nondir orphanage/2902474338.2817943331 to var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/02-Compte rendu de réunions/Compte rendu réunion 3 mai 2016.odt: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: unable to rename nondir orphanage/2902474340.2817943331 to var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/02-Compte rendu de réunions/Compte rendu réunion 3 mai 2016.pdf: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: unable to rename nondir orphanage/186255753.103400553 to var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/01-Documents préparatoires/Questionnaire initial - AMBOISE.pdf: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: unable to rename nondir orphanage/2952829056.3301423653 to var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Planification.gan.v1462378955: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: unable to rename nondir orphanage/2952829025.3301423651 to var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Collecte d'informations Amboise.xlsx.v1459347620: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: unable to rename nondir orphanage/2902463620.1603825313 to var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Collecte d'informations Amboise.xlsx: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: unable to rename nondir orphanage/2952829061.3301423650 to var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/02-Compte rendu de réunions/Compte rendu réunion 3 mai 2016.pdf.v1462362659: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: unable to rename nondir orphanage/2952829062.3301423650 to var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/02-Compte rendu de réunions/Compte rendu réunion 3 mai 2016.odt.v1462365509: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: unable to rename nondir orphanage/2952829058.3301423651 to var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/02-Compte rendu de réunions/Compte rendu réunion 3 mai 2016.odt.v1462365141: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: unable to rename nondir orphanage/2952829063.3301423650 to var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/02-Compte rendu de réunions/Compte rendu réunion 3 mai 2016.pdf.v1462365556: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: unable to rename nondir orphanage/2902474342.2817943330 to var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/04-Etude réseau/Schema réseau actualisé.png: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: unable to rename nondir orphanage/2952829055.3301423651 to var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/02-Compte rendu de réunions/Compte rendu réunion 3 mai 2016.odt.v1462362656: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: unable to rename nondir orphanage/2902474343.2817943328 to var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/04-Etude réseau/Schema réseau actualisé.graphml: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: unable to rename nondir orphanage/2952829059.3301423650 to var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/02-Compte rendu de réunions/Compte rendu réunion 3 mai 2016.odt.v1462349557: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: unable to rename nondir orphanage/2902551900.2044032635 to var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Initialisation parapheur/Circuits du parapheur.graphml: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: unable to rename nondir orphanage/2902551901.2044032635 to var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Initialisation parapheur/Circuits du parapheur.png: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: unable to rename nondir orphanage/2952829057.3301423651 to var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/04-Etude réseau/Schema réseau actualisé.png.v1462361172: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: unable to rename nondir orphanage/2952829054.3301423650 to var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/02-Compte rendu de réunions/Compte rendu réunion 3 mai 2016.odt.v1462343392: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: unable to rename nondir orphanage/1711326188.435972671 to orphanage/1711276202.4274102453/Portail e-collectivité - Scénario Budget Epci et communes.xlsx.v1457357181: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: unable to rename nondir orphanage/2902474346.2817943328 to var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Planification.gan: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: restoring non-directory files
xfsrestore: drive 0: inventory session uuid (8693d7f5-395a-41c4-bb8c-dbbaa7dc7a57) does not match the media header's session uuid (6ca00754-b885-4d2f-8785-e0399961c765)
xfsrestore: drive 1: NOTE: ino 51196832 gen 3433304555 not referenced: placing in orphanage
xfsrestore: drive 1: NOTE: ino 51196834 gen 3433298241 not referenced: placing in orphanage
xfsrestore: drive 1: NOTE: ino 51196835 gen 3433289569 not referenced: placing in orphanage
xfsrestore: drive 1: NOTE: ino 51196836 gen 3433286216 not referenced: placing in orphanage
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Initialisation parapheur/Demandes de subvention - multi circuits.graphml failed: Aucun fichier ou dossier de ce type: discarding ino 139111915
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Initialisation parapheur/Demandes de subvention - mono circuit - multi avis.graphml failed: Aucun fichier ou dossier de ce type: discarding ino 139111917
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Initialisation parapheur/Demandes de subvention - mono circuit.graphml failed: Aucun fichier ou dossier de ce type: discarding ino 139111918
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Initialisation parapheur/Demandes de subvention - mono circuit.png failed: Aucun fichier ou dossier de ce type: discarding ino 139111919
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Initialisation parapheur/Demandes de subvention - multi circuits - multi avis.graphml failed: Aucun fichier ou dossier de ce type: discarding ino 139111920
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Initialisation parapheur/Demandes de subvention - multi circuits - multi avis.png failed: Aucun fichier ou dossier de ce type: discarding ino 139111921
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Initialisation parapheur/Demandes de subvention - mono circuit - multi avis.png failed: Aucun fichier ou dossier de ce type: discarding ino 139111922
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Initialisation parapheur/Demandes de subvention - multi circuits.png failed: Aucun fichier ou dossier de ce type: discarding ino 139111923
xfsrestore: drive 1: WARNING: attempt to link orphanage/186255753.103400553 to var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/01-Documents préparatoires/Questionnaire initial - AMBOISE.pdf failed: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/200018323 - CC Canton de Beaugency/cc-beaugency.ods failed: Aucun fichier ou dossier de ce type: discarding ino 372614784
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Initialisation parapheur/Demandes de subvention - multi circuits.graphml.v1464365887 failed: Aucun fichier ou dossier de ce type: discarding ino 393730159
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Initialisation parapheur/Demandes de subvention - multi circuits.graphml.v1464366909 failed: Aucun fichier ou dossier de ce type: discarding ino 393730160
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Initialisation parapheur/Demandes de subvention - multi circuits.png.v1464366935 failed: Aucun fichier ou dossier de ce type: discarding ino 393730161
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Initialisation parapheur/Demandes de subvention - mono circuit - multi avis.graphml.v1464368341 failed: Aucun fichier ou dossier de ce type: discarding ino 393730162
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Initialisation parapheur/Demandes de subvention - mono circuit - multi avis.graphml.v1464369151 failed: Aucun fichier ou dossier de ce type: discarding ino 393730163
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Initialisation parapheur/Demandes de subvention - mono circuit - multi avis.png.v1464369156 failed: Aucun fichier ou dossier de ce type: discarding ino 393730164
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Initialisation parapheur/Demandes de subvention - multi circuits - multi avis.graphml.v1464368128 failed: Aucun fichier ou dossier de ce type: discarding ino 393730165
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Initialisation parapheur/Demandes de subvention - multi circuits.graphml.v1464367523 failed: Aucun fichier ou dossier de ce type: discarding ino 393730166
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Initialisation parapheur/Demandes de subvention - multi circuits.png.v1464367528 failed: Aucun fichier ou dossier de ce type: discarding ino 393730167
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Initialisation parapheur/Demandes de subvention - mono circuit.graphml.v1464366401 failed: Aucun fichier ou dossier de ce type: discarding ino 393730168
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Initialisation parapheur/Demandes de subvention - mono circuit.png.v1464366927 failed: Aucun fichier ou dossier de ce type: discarding ino 393730169
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Initialisation parapheur/Demandes de subvention - mono circuit - multi avis.graphml.v1464369336 failed: Aucun fichier ou dossier de ce type: discarding ino 393730170
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Initialisation parapheur/Demandes de subvention - mono circuit - multi avis.png.v1464369341 failed: Aucun fichier ou dossier de ce type: discarding ino 393730171
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Initialisation parapheur/Demandes de subvention - mono circuit - multi avis.graphml.v1464369669 failed: Aucun fichier ou dossier de ce type: discarding ino 393730172
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Initialisation parapheur/Demandes de subvention - mono circuit - multi avis.png.v1464369673 failed: Aucun fichier ou dossier de ce type: discarding ino 393730173
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/05 Formations/Conventions avec EPN/GIP Recia2016_V1-2.pdf failed: Aucun fichier ou dossier de ce type: discarding ino 822256228
xfsrestore: drive 1: NOTE: ino 1124073740 gen 1863069171 not referenced: placing in orphanage
xfsrestore: drive 1: WARNING: unable to bind UNIX domain socket ino 1207963216 tmp/tmux-0/default: Adresse déjà utilisée: discarding
xfsrestore: drive 1: WARNING: open of orphanage/1677721775.4173752252/Mots de passe SOLAERE.kdbx failed: Aucun fichier ou dossier de ce type: discarding ino 1677795044
xfsrestore: drive 1: WARNING: open of orphanage/1694499004.2655526171/Guide recia de la e-administration v2.pptx.v1458557329 failed: Aucun fichier ou dossier de ce type: discarding ino 1694498973
xfsrestore: drive 1: WARNING: open of orphanage/1694499004.2655526171/Courrier invitation présentation sOlære à Ste Maure.docx.v1463145748 failed: Aucun fichier ou dossier de ce type: discarding ino 1694498987
xfsrestore: drive 1: WARNING: open of orphanage/1694499004.2655526171/Fiche Produit - Télétransmission des mails sécurisés.docx.v1463555193 failed: Aucun fichier ou dossier de ce type: discarding ino 1695370123
xfsrestore: drive 1: WARNING: open of orphanage/1694499004.2655526171/Présentation plateforme e-collectivité sOlære v2 du 05.04.16.pptx.v1460125314 failed: Aucun fichier ou dossier de ce type: discarding ino 1695370124
xfsrestore: drive 1: WARNING: open of orphanage/1694499004.2655526171/Fiche Produit - Télétransmission des flux comptables.docx.v1463490998 failed: Aucun fichier ou dossier de ce type: discarding ino 1695370128
xfsrestore: drive 1: WARNING: open of orphanage/1694499004.2655526171/Présentation plateforme e-collectivité sOlære v2 du 05.04.16.pptx.v1463574154 failed: Aucun fichier ou dossier de ce type: discarding ino 1695370129
xfsrestore: drive 1: WARNING: open of orphanage/1694499004.2655526171/Fiche Produit - Télétransmission des flux comptables.docx.v1463495871 failed: Aucun fichier ou dossier de ce type: discarding ino 1695370133
xfsrestore: drive 1: WARNING: open of orphanage/1694499004.2655526171/Fiche Produit - Télétransmission des mails sécurisés.docx.v1463500385 failed: Aucun fichier ou dossier de ce type: discarding ino 1695370134
xfsrestore: drive 1: WARNING: open of orphanage/1711276202.4274102453/Suivi des collectivités.ods.v1460723560 failed: Aucun fichier ou dossier de ce type: discarding ino 1711276206
xfsrestore: drive 1: WARNING: open of orphanage/1711276202.4274102453/Suivi des collectivités.ods.v1462958081 failed: Aucun fichier ou dossier de ce type: discarding ino 1711276207
xfsrestore: drive 1: WARNING: open of orphanage/1711276202.4274102453/Suivi des collectivités.ods.v1463053409 failed: Aucun fichier ou dossier de ce type: discarding ino 1711326183
xfsrestore: drive 1: WARNING: attempt to link orphanage/1711326188.435972671 to orphanage/1711276202.4274102453/Portail e-collectivité - Scénario Budget Epci et communes.xlsx.v1457357181 failed: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: open of orphanage/1694499004.2655526171/Images/Logo Solaere e-administration-2560x1440.jpg.v1464106609 failed: Aucun fichier ou dossier de ce type: discarding ino 2248231640
xfsrestore: drive 1: WARNING: open of orphanage/1694499004.2655526171/Images/Logo Solaere e-administration-2560x1440.jpg.v1464106751 failed: Aucun fichier ou dossier de ce type: discarding ino 2248231641
xfsrestore: drive 1: WARNING: open of orphanage/1694499004.2655526171/Images/Logo Solaere e-administration-2560x1440.jpg.v1464106927 failed: Aucun fichier ou dossier de ce type: discarding ino 2248231643
xfsrestore: drive 1: WARNING: open of orphanage/1694499004.2655526171/Images/Logo Solaere e-administration-2560x1440.jpg.v1464107007 failed: Aucun fichier ou dossier de ce type: discarding ino 2248231645
xfsrestore: drive 1: WARNING: open of orphanage/1694499004.2655526171/Images/Logo Solaere e-administration-2560x1440.jpg.v1464107074 failed: Aucun fichier ou dossier de ce type: discarding ino 2248231646
xfsrestore: drive 1: WARNING: open of orphanage/1694499004.2655526171/Images/Logo Solaere e-administration-2560x1440.jpg.v1464107149 failed: Aucun fichier ou dossier de ce type: discarding ino 2248231648
xfsrestore: drive 1: WARNING: open of orphanage/2365644069.2895542759/Mots de passe SOLAERE.kdbx.v1462786944 failed: Aucun fichier ou dossier de ce type: discarding ino 2365678230
xfsrestore: drive 1: WARNING: open of orphanage/2365644069.2895542759/Mots de passe SOLAERE.kdbx.v1462979590 failed: Aucun fichier ou dossier de ce type: discarding ino 2365678263
xfsrestore: drive 1: WARNING: open of orphanage/2365644069.2895542759/Mots de passe SOLAERE.kdbx.v1463149246 failed: Aucun fichier ou dossier de ce type: discarding ino 2365678264
xfsrestore: drive 1: WARNING: open of orphanage/2365644069.2895542759/Mots de passe SOLAERE.kdbx.v1463722642 failed: Aucun fichier ou dossier de ce type: discarding ino 2365704464
xfsrestore: drive 1: WARNING: open of orphanage/2365644069.2895542759/Mots de passe SOLAERE.kdbx.v1461930698 failed: Aucun fichier ou dossier de ce type: discarding ino 2365795807
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/45000 - Prefecture de région - SGAR/comptes de demo sur preprod.pdf failed: Aucun fichier ou dossier de ce type: discarding ino 2701315169
xfsrestore: drive 1: WARNING: attempt to link orphanage/2902463620.1603825313 to var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Collecte d'informations Amboise.xlsx failed: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: attempt to link orphanage/2902474338.2817943331 to var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/02-Compte rendu de réunions/Compte rendu réunion 3 mai 2016.odt failed: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: attempt to link orphanage/2902474340.2817943331 to var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/02-Compte rendu de réunions/Compte rendu réunion 3 mai 2016.pdf failed: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: attempt to link orphanage/2902474342.2817943330 to var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/04-Etude réseau/Schema réseau actualisé.png failed: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: attempt to link orphanage/2902474343.2817943328 to var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/04-Etude réseau/Schema réseau actualisé.graphml failed: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: attempt to link orphanage/2902474346.2817943328 to var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Planification.gan failed: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/04-Etude réseau/Proposition Adista Amboise-1.xlsx failed: Aucun fichier ou dossier de ce type: discarding ino 2902474358
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Documents d'initialisation idélibre/Convoc blanche.doc failed: Aucun fichier ou dossier de ce type: discarding ino 2902474362
xfsrestore: drive 1: WARNING: attempt to link orphanage/2902551900.2044032635 to var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Initialisation parapheur/Circuits du parapheur.graphml failed: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: attempt to link orphanage/2902551901.2044032635 to var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Initialisation parapheur/Circuits du parapheur.png failed: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Documents d'initialisation idélibre/Ordre du jour commission Aff. Generales, RH et demographie.doc failed: Aucun fichier ou dossier de ce type: discarding ino 2902651922
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Documents d'initialisation idélibre/conv aff generales RH et dmeographie blanche.doc failed: Aucun fichier ou dossier de ce type: discarding ino 2902651923
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Documents d'initialisation idélibre/ordre du jour CM 1er Avril 2016.pdf failed: Aucun fichier ou dossier de ce type: discarding ino 2902651924
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Documents d'initialisation idélibre/LISTE CM 2014.xls failed: Aucun fichier ou dossier de ce type: discarding ino 2902651925
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/05-Déclaration CNIL/MAIRIE D'AMBOISE- déclarations cnil.pdf failed: Aucun fichier ou dossier de ce type: discarding ino 2902661038
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Schema parapheur.odg failed: Aucun fichier ou dossier de ce type: discarding ino 2902843987
xfsrestore: drive 1: WARNING: attempt to link orphanage/2952829025.3301423651 to var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Collecte d'informations Amboise.xlsx.v1459347620 failed: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: attempt to link orphanage/2952829054.3301423650 to var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/02-Compte rendu de réunions/Compte rendu réunion 3 mai 2016.odt.v1462343392 failed: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: attempt to link orphanage/2952829055.3301423651 to var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/02-Compte rendu de réunions/Compte rendu réunion 3 mai 2016.odt.v1462362656 failed: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: attempt to link orphanage/2952829056.3301423653 to var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Planification.gan.v1462378955 failed: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: attempt to link orphanage/2952829057.3301423651 to var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/04-Etude réseau/Schema réseau actualisé.png.v1462361172 failed: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: attempt to link orphanage/2952829058.3301423651 to var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/02-Compte rendu de réunions/Compte rendu réunion 3 mai 2016.odt.v1462365141 failed: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: attempt to link orphanage/2952829059.3301423650 to var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/02-Compte rendu de réunions/Compte rendu réunion 3 mai 2016.odt.v1462349557 failed: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: attempt to link orphanage/2952829061.3301423650 to var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/02-Compte rendu de réunions/Compte rendu réunion 3 mai 2016.pdf.v1462362659 failed: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: attempt to link orphanage/2952829062.3301423650 to var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/02-Compte rendu de réunions/Compte rendu réunion 3 mai 2016.odt.v1462365509 failed: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: attempt to link orphanage/2952829063.3301423650 to var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/02-Compte rendu de réunions/Compte rendu réunion 3 mai 2016.pdf.v1462365556 failed: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Documents d'initialisation idélibre/LISTE CM 2014.xls.v1462951463 failed: Aucun fichier ou dossier de ce type: discarding ino 2952829070
xfsrestore: drive 1: WARNING: unable to rmdir /mnt/restore//orphanage: Le dossier n'est pas vide
xfsrestore: restore complete: 610 seconds elapsed
xfsrestore: Restore Summary:
xfsrestore:   stream 0 /mnt/backup-owncloud/xfsdump/owncloud-+-L0-2016-05-07-02-10.dump OK (success)
xfsrestore:   stream 1 /mnt/backup-owncloud/xfsdump/owncloud-+-L1-2016-05-29-02-10.dump OK (success)
xfsrestore: Restore Status: SUCCESS

The restoration is inconsistent.
Some folders are not restored at the right place.
And they are a lots of missing files in some directories.
Is this a bug in xfsdump/xfsrestore ?
Any help would be appreciated.

I use CentOS 7.2 and xfsdump-3.1.4-1.el7.x86_64.

Regards.

--
Damien Gombault


--------------A21625E3864E2E4E4F99257C
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: 8bit

<html>
  <head>

    <meta http-equiv="content-type" content="text/html; charset=utf-8">
  </head>
  <body bgcolor="#FFFFFF" text="#000000">
    <pre class="bz_comment_text
                 bz_wrap_comment_text" id="comment_text_0">Hi.

I use xfsdump to backup my systems.
Recently I had to use xfsrestore to restore a cumulative level 0 + level 1 dumps.

The level 0 dump log is :
/usr/sbin/xfsdump: using file dump (drive_simple) strategy
/usr/sbin/xfsdump: version 3.1.4 (dump format 3.0)
/usr/sbin/xfsdump: level 0 dump of owncloud:/
/usr/sbin/xfsdump: dump date: Sat May  7 02:10:04 2016
/usr/sbin/xfsdump: session id: 6ca00754-b885-4d2f-8785-e0399961c765
/usr/sbin/xfsdump: session label: "machine:owncloud partition:/ level:0 date:2016-05-07-02-10"
/usr/sbin/xfsdump: ino map phase 1: constructing initial dump list
/usr/sbin/xfsdump: ino map phase 2: skipping (no pruning necessary)
/usr/sbin/xfsdump: ino map phase 3: skipping (only one dump stream)
/usr/sbin/xfsdump: ino map construction complete
/usr/sbin/xfsdump: estimated dump size: 216034001408 bytes
/usr/sbin/xfsdump: creating dump session media file 0 (media 0, file 0)
/usr/sbin/xfsdump: dumping ino map
/usr/sbin/xfsdump: dumping directories
/usr/sbin/xfsdump: dumping non-directory files
/usr/sbin/xfsdump: ending media file
/usr/sbin/xfsdump: media file size 215829487392 bytes
/usr/sbin/xfsdump: dump size (non-dir files) : 215703283288 bytes
/usr/sbin/xfsdump: dump complete: 6199 seconds elapsed
/usr/sbin/xfsdump: Dump Summary:
/usr/sbin/xfsdump:   stream 0 /mnt/backup/xfsdump/owncloud-+-L0-2016-05-07-02-10.dump OK (success)
/usr/sbin/xfsdump: Dump Status: SUCCESS

The level 1 dump log is :
/usr/sbin/xfsdump: using file dump (drive_simple) strategy
/usr/sbin/xfsdump: version 3.1.4 (dump format 3.0)
/usr/sbin/xfsdump: level 1 incremental dump of owncloud:/ based on level 0 dump begun Sat May  7 02:10:04 2016
/usr/sbin/xfsdump: dump date: Sun May 29 02:10:04 2016
/usr/sbin/xfsdump: session id: 8693d7f5-395a-41c4-bb8c-dbbaa7dc7a57
/usr/sbin/xfsdump: session label: "machine:owncloud partition:/ level:1 date:2016-05-29-02-10"
/usr/sbin/xfsdump: ino map phase 1: constructing initial dump list
/usr/sbin/xfsdump: ino map phase 2: pruning unneeded subtrees
/usr/sbin/xfsdump: ino map phase 3: skipping (only one dump stream)
/usr/sbin/xfsdump: ino map construction complete
/usr/sbin/xfsdump: estimated dump size: 38360233792 bytes
/usr/sbin/xfsdump: creating dump session media file 0 (media 0, file 0)
/usr/sbin/xfsdump: dumping ino map
/usr/sbin/xfsdump: dumping directories
/usr/sbin/xfsdump: dumping non-directory files
/usr/sbin/xfsdump: ending media file
/usr/sbin/xfsdump: media file size 38266860896 bytes
/usr/sbin/xfsdump: dump size (non-dir files) : 38240915448 bytes
/usr/sbin/xfsdump: dump complete: 10506 seconds elapsed
/usr/sbin/xfsdump: Dump Summary:
/usr/sbin/xfsdump:   stream 0 /mnt/backup/xfsdump/owncloud-+-L1-2016-05-29-02-10.dump OK (success)
/usr/sbin/xfsdump: Dump Status: SUCCESS

The 2 dumps seems OK.

I created a new XFS file system.
I restored the level 0 dump on it with option -r (cumulative mode).
Then I restored the level 1 dump on it with the same options.

The level 0 restore is OK :
xfsrestore: drive 1: searching media for dump
xfsrestore: drive 0: searching media for directory dump
xfsrestore: drive 1: examining media file 0
xfsrestore: drive 1: searching media for directory dump
xfsrestore: drive 1: inventory session uuid (6ca00754-b885-4d2f-8785-e0399961c765) does not match the media header's session uuid (8693d7f5-395a-41c4-bb8c-dbbaa7dc7a57)
xfsrestore: drive 0: reading directories
xfsrestore: drive 0: 53796 directories and 370906 entries processed
xfsrestore: drive 0: directory post-processing
xfsrestore: drive 0: restoring non-directory files
xfsrestore: drive 0: NOTE: ino 51480542 gen 1438712790 not referenced: placing in orphanage
xfsrestore: drive 0: NOTE: ino 51480551 gen 1438712713 not referenced: placing in orphanage
xfsrestore: drive 0: WARNING: unable to rmdir /mnt/restore//orphanage: Le dossier n'est pas vide
xfsrestore: restore complete: 2764 seconds elapsed
xfsrestore: Restore Summary:
xfsrestore:   stream 0 /mnt/backup-owncloud/xfsdump/owncloud-+-L0-2016-05-07-02-10.dump OK (success)
xfsrestore:   stream 1 /mnt/backup-owncloud/xfsdump/owncloud-+-L1-2016-05-29-02-10.dump OK (success)
xfsrestore: Restore Status: SUCCESS

The 2 ino referenced is empty files, I suppose it was some empty PHP session files deleted during dump.

The level 1 restore shows many warnings :
xfsrestore: drive 0: examining media file 0
xfsrestore: drive 1: searching media for directory dump
xfsrestore: drive 1: reading directories
xfsrestore: drive 1: 11013 directories and 96122 entries processed
xfsrestore: drive 1: directory post-processing
xfsrestore: drive 1: WARNING: unable to rename dir orphanage/1677721775.4173752252 to dir var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/08 Sécurité/08c Gestion des mots de passe - Keepass: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: unable to rename dir orphanage/1711276202.4274102453 to dir var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/02 Mise en oeuvre sOlære: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: unable to rename dir orphanage/1694499004.2655526171 to dir var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/07 Communication: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: unable to rename dir orphanage/2365644069.2895542759 to dir var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/08 Sécurité/08c Gestion des mots de passe - Keepass: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: unable to rename nondir orphanage/2902474338.2817943331 to var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/02-Compte rendu de réunions/Compte rendu réunion 3 mai 2016.odt: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: unable to rename nondir orphanage/2902474340.2817943331 to var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/02-Compte rendu de réunions/Compte rendu réunion 3 mai 2016.pdf: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: unable to rename nondir orphanage/186255753.103400553 to var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/01-Documents préparatoires/Questionnaire initial - AMBOISE.pdf: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: unable to rename nondir orphanage/2952829056.3301423653 to var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Planification.gan.v1462378955: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: unable to rename nondir orphanage/2952829025.3301423651 to var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Collecte d'informations Amboise.xlsx.v1459347620: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: unable to rename nondir orphanage/2902463620.1603825313 to var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Collecte d'informations Amboise.xlsx: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: unable to rename nondir orphanage/2952829061.3301423650 to var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/02-Compte rendu de réunions/Compte rendu réunion 3 mai 2016.pdf.v1462362659: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: unable to rename nondir orphanage/2952829062.3301423650 to var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/02-Compte rendu de réunions/Compte rendu réunion 3 mai 2016.odt.v1462365509: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: unable to rename nondir orphanage/2952829058.3301423651 to var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/02-Compte rendu de réunions/Compte rendu réunion 3 mai 2016.odt.v1462365141: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: unable to rename nondir orphanage/2952829063.3301423650 to var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/02-Compte rendu de réunions/Compte rendu réunion 3 mai 2016.pdf.v1462365556: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: unable to rename nondir orphanage/2902474342.2817943330 to var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/04-Etude réseau/Schema réseau actualisé.png: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: unable to rename nondir orphanage/2952829055.3301423651 to var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/02-Compte rendu de réunions/Compte rendu réunion 3 mai 2016.odt.v1462362656: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: unable to rename nondir orphanage/2902474343.2817943328 to var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/04-Etude réseau/Schema réseau actualisé.graphml: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: unable to rename nondir orphanage/2952829059.3301423650 to var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/02-Compte rendu de réunions/Compte rendu réunion 3 mai 2016.odt.v1462349557: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: unable to rename nondir orphanage/2902551900.2044032635 to var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Initialisation parapheur/Circuits du parapheur.graphml: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: unable to rename nondir orphanage/2902551901.2044032635 to var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Initialisation parapheur/Circuits du parapheur.png: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: unable to rename nondir orphanage/2952829057.3301423651 to var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/04-Etude réseau/Schema réseau actualisé.png.v1462361172: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: unable to rename nondir orphanage/2952829054.3301423650 to var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/02-Compte rendu de réunions/Compte rendu réunion 3 mai 2016.odt.v1462343392: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: unable to rename nondir orphanage/1711326188.435972671 to orphanage/1711276202.4274102453/Portail e-collectivité - Scénario Budget Epci et communes.xlsx.v1457357181: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: unable to rename nondir orphanage/2902474346.2817943328 to var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Planification.gan: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: restoring non-directory files
xfsrestore: drive 0: inventory session uuid (8693d7f5-395a-41c4-bb8c-dbbaa7dc7a57) does not match the media header's session uuid (6ca00754-b885-4d2f-8785-e0399961c765)
xfsrestore: drive 1: NOTE: ino 51196832 gen 3433304555 not referenced: placing in orphanage
xfsrestore: drive 1: NOTE: ino 51196834 gen 3433298241 not referenced: placing in orphanage
xfsrestore: drive 1: NOTE: ino 51196835 gen 3433289569 not referenced: placing in orphanage
xfsrestore: drive 1: NOTE: ino 51196836 gen 3433286216 not referenced: placing in orphanage
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Initialisation parapheur/Demandes de subvention - multi circuits.graphml failed: Aucun fichier ou dossier de ce type: discarding ino 139111915
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Initialisation parapheur/Demandes de subvention - mono circuit - multi avis.graphml failed: Aucun fichier ou dossier de ce type: discarding ino 139111917
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Initialisation parapheur/Demandes de subvention - mono circuit.graphml failed: Aucun fichier ou dossier de ce type: discarding ino 139111918
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Initialisation parapheur/Demandes de subvention - mono circuit.png failed: Aucun fichier ou dossier de ce type: discarding ino 139111919
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Initialisation parapheur/Demandes de subvention - multi circuits - multi avis.graphml failed: Aucun fichier ou dossier de ce type: discarding ino 139111920
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Initialisation parapheur/Demandes de subvention - multi circuits - multi avis.png failed: Aucun fichier ou dossier de ce type: discarding ino 139111921
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Initialisation parapheur/Demandes de subvention - mono circuit - multi avis.png failed: Aucun fichier ou dossier de ce type: discarding ino 139111922
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Initialisation parapheur/Demandes de subvention - multi circuits.png failed: Aucun fichier ou dossier de ce type: discarding ino 139111923
xfsrestore: drive 1: WARNING: attempt to link orphanage/186255753.103400553 to var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/01-Documents préparatoires/Questionnaire initial - AMBOISE.pdf failed: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/200018323 - CC Canton de Beaugency/cc-beaugency.ods failed: Aucun fichier ou dossier de ce type: discarding ino 372614784
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Initialisation parapheur/Demandes de subvention - multi circuits.graphml.v1464365887 failed: Aucun fichier ou dossier de ce type: discarding ino 393730159
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Initialisation parapheur/Demandes de subvention - multi circuits.graphml.v1464366909 failed: Aucun fichier ou dossier de ce type: discarding ino 393730160
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Initialisation parapheur/Demandes de subvention - multi circuits.png.v1464366935 failed: Aucun fichier ou dossier de ce type: discarding ino 393730161
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Initialisation parapheur/Demandes de subvention - mono circuit - multi avis.graphml.v1464368341 failed: Aucun fichier ou dossier de ce type: discarding ino 393730162
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Initialisation parapheur/Demandes de subvention - mono circuit - multi avis.graphml.v1464369151 failed: Aucun fichier ou dossier de ce type: discarding ino 393730163
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Initialisation parapheur/Demandes de subvention - mono circuit - multi avis.png.v1464369156 failed: Aucun fichier ou dossier de ce type: discarding ino 393730164
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Initialisation parapheur/Demandes de subvention - multi circuits - multi avis.graphml.v1464368128 failed: Aucun fichier ou dossier de ce type: discarding ino 393730165
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Initialisation parapheur/Demandes de subvention - multi circuits.graphml.v1464367523 failed: Aucun fichier ou dossier de ce type: discarding ino 393730166
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Initialisation parapheur/Demandes de subvention - multi circuits.png.v1464367528 failed: Aucun fichier ou dossier de ce type: discarding ino 393730167
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Initialisation parapheur/Demandes de subvention - mono circuit.graphml.v1464366401 failed: Aucun fichier ou dossier de ce type: discarding ino 393730168
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Initialisation parapheur/Demandes de subvention - mono circuit.png.v1464366927 failed: Aucun fichier ou dossier de ce type: discarding ino 393730169
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Initialisation parapheur/Demandes de subvention - mono circuit - multi avis.graphml.v1464369336 failed: Aucun fichier ou dossier de ce type: discarding ino 393730170
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Initialisation parapheur/Demandes de subvention - mono circuit - multi avis.png.v1464369341 failed: Aucun fichier ou dossier de ce type: discarding ino 393730171
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Initialisation parapheur/Demandes de subvention - mono circuit - multi avis.graphml.v1464369669 failed: Aucun fichier ou dossier de ce type: discarding ino 393730172
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Initialisation parapheur/Demandes de subvention - mono circuit - multi avis.png.v1464369673 failed: Aucun fichier ou dossier de ce type: discarding ino 393730173
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/05 Formations/Conventions avec EPN/GIP Recia2016_V1-2.pdf failed: Aucun fichier ou dossier de ce type: discarding ino 822256228
xfsrestore: drive 1: NOTE: ino 1124073740 gen 1863069171 not referenced: placing in orphanage
xfsrestore: drive 1: WARNING: unable to bind UNIX domain socket ino 1207963216 tmp/tmux-0/default: Adresse déjà utilisée: discarding
xfsrestore: drive 1: WARNING: open of orphanage/1677721775.4173752252/Mots de passe SOLAERE.kdbx failed: Aucun fichier ou dossier de ce type: discarding ino 1677795044
xfsrestore: drive 1: WARNING: open of orphanage/1694499004.2655526171/Guide recia de la e-administration v2.pptx.v1458557329 failed: Aucun fichier ou dossier de ce type: discarding ino 1694498973
xfsrestore: drive 1: WARNING: open of orphanage/1694499004.2655526171/Courrier invitation présentation sOlære à Ste Maure.docx.v1463145748 failed: Aucun fichier ou dossier de ce type: discarding ino 1694498987
xfsrestore: drive 1: WARNING: open of orphanage/1694499004.2655526171/Fiche Produit - Télétransmission des mails sécurisés.docx.v1463555193 failed: Aucun fichier ou dossier de ce type: discarding ino 1695370123
xfsrestore: drive 1: WARNING: open of orphanage/1694499004.2655526171/Présentation plateforme e-collectivité sOlære v2 du 05.04.16.pptx.v1460125314 failed: Aucun fichier ou dossier de ce type: discarding ino 1695370124
xfsrestore: drive 1: WARNING: open of orphanage/1694499004.2655526171/Fiche Produit - Télétransmission des flux comptables.docx.v1463490998 failed: Aucun fichier ou dossier de ce type: discarding ino 1695370128
xfsrestore: drive 1: WARNING: open of orphanage/1694499004.2655526171/Présentation plateforme e-collectivité sOlære v2 du 05.04.16.pptx.v1463574154 failed: Aucun fichier ou dossier de ce type: discarding ino 1695370129
xfsrestore: drive 1: WARNING: open of orphanage/1694499004.2655526171/Fiche Produit - Télétransmission des flux comptables.docx.v1463495871 failed: Aucun fichier ou dossier de ce type: discarding ino 1695370133
xfsrestore: drive 1: WARNING: open of orphanage/1694499004.2655526171/Fiche Produit - Télétransmission des mails sécurisés.docx.v1463500385 failed: Aucun fichier ou dossier de ce type: discarding ino 1695370134
xfsrestore: drive 1: WARNING: open of orphanage/1711276202.4274102453/Suivi des collectivités.ods.v1460723560 failed: Aucun fichier ou dossier de ce type: discarding ino 1711276206
xfsrestore: drive 1: WARNING: open of orphanage/1711276202.4274102453/Suivi des collectivités.ods.v1462958081 failed: Aucun fichier ou dossier de ce type: discarding ino 1711276207
xfsrestore: drive 1: WARNING: open of orphanage/1711276202.4274102453/Suivi des collectivités.ods.v1463053409 failed: Aucun fichier ou dossier de ce type: discarding ino 1711326183
xfsrestore: drive 1: WARNING: attempt to link orphanage/1711326188.435972671 to orphanage/1711276202.4274102453/Portail e-collectivité - Scénario Budget Epci et communes.xlsx.v1457357181 failed: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: open of orphanage/1694499004.2655526171/Images/Logo Solaere e-administration-2560x1440.jpg.v1464106609 failed: Aucun fichier ou dossier de ce type: discarding ino 2248231640
xfsrestore: drive 1: WARNING: open of orphanage/1694499004.2655526171/Images/Logo Solaere e-administration-2560x1440.jpg.v1464106751 failed: Aucun fichier ou dossier de ce type: discarding ino 2248231641
xfsrestore: drive 1: WARNING: open of orphanage/1694499004.2655526171/Images/Logo Solaere e-administration-2560x1440.jpg.v1464106927 failed: Aucun fichier ou dossier de ce type: discarding ino 2248231643
xfsrestore: drive 1: WARNING: open of orphanage/1694499004.2655526171/Images/Logo Solaere e-administration-2560x1440.jpg.v1464107007 failed: Aucun fichier ou dossier de ce type: discarding ino 2248231645
xfsrestore: drive 1: WARNING: open of orphanage/1694499004.2655526171/Images/Logo Solaere e-administration-2560x1440.jpg.v1464107074 failed: Aucun fichier ou dossier de ce type: discarding ino 2248231646
xfsrestore: drive 1: WARNING: open of orphanage/1694499004.2655526171/Images/Logo Solaere e-administration-2560x1440.jpg.v1464107149 failed: Aucun fichier ou dossier de ce type: discarding ino 2248231648
xfsrestore: drive 1: WARNING: open of orphanage/2365644069.2895542759/Mots de passe SOLAERE.kdbx.v1462786944 failed: Aucun fichier ou dossier de ce type: discarding ino 2365678230
xfsrestore: drive 1: WARNING: open of orphanage/2365644069.2895542759/Mots de passe SOLAERE.kdbx.v1462979590 failed: Aucun fichier ou dossier de ce type: discarding ino 2365678263
xfsrestore: drive 1: WARNING: open of orphanage/2365644069.2895542759/Mots de passe SOLAERE.kdbx.v1463149246 failed: Aucun fichier ou dossier de ce type: discarding ino 2365678264
xfsrestore: drive 1: WARNING: open of orphanage/2365644069.2895542759/Mots de passe SOLAERE.kdbx.v1463722642 failed: Aucun fichier ou dossier de ce type: discarding ino 2365704464
xfsrestore: drive 1: WARNING: open of orphanage/2365644069.2895542759/Mots de passe SOLAERE.kdbx.v1461930698 failed: Aucun fichier ou dossier de ce type: discarding ino 2365795807
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/45000 - Prefecture de région - SGAR/comptes de demo sur preprod.pdf failed: Aucun fichier ou dossier de ce type: discarding ino 2701315169
xfsrestore: drive 1: WARNING: attempt to link orphanage/2902463620.1603825313 to var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Collecte d'informations Amboise.xlsx failed: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: attempt to link orphanage/2902474338.2817943331 to var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/02-Compte rendu de réunions/Compte rendu réunion 3 mai 2016.odt failed: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: attempt to link orphanage/2902474340.2817943331 to var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/02-Compte rendu de réunions/Compte rendu réunion 3 mai 2016.pdf failed: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: attempt to link orphanage/2902474342.2817943330 to var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/04-Etude réseau/Schema réseau actualisé.png failed: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: attempt to link orphanage/2902474343.2817943328 to var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/04-Etude réseau/Schema réseau actualisé.graphml failed: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: attempt to link orphanage/2902474346.2817943328 to var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Planification.gan failed: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/04-Etude réseau/Proposition Adista Amboise-1.xlsx failed: Aucun fichier ou dossier de ce type: discarding ino 2902474358
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Documents d'initialisation idélibre/Convoc blanche.doc failed: Aucun fichier ou dossier de ce type: discarding ino 2902474362
xfsrestore: drive 1: WARNING: attempt to link orphanage/2902551900.2044032635 to var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Initialisation parapheur/Circuits du parapheur.graphml failed: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: attempt to link orphanage/2902551901.2044032635 to var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Initialisation parapheur/Circuits du parapheur.png failed: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Documents d'initialisation idélibre/Ordre du jour commission Aff. Generales, RH et demographie.doc failed: Aucun fichier ou dossier de ce type: discarding ino 2902651922
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Documents d'initialisation idélibre/conv aff generales RH et dmeographie blanche.doc failed: Aucun fichier ou dossier de ce type: discarding ino 2902651923
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Documents d'initialisation idélibre/ordre du jour CM 1er Avril 2016.pdf failed: Aucun fichier ou dossier de ce type: discarding ino 2902651924
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Documents d'initialisation idélibre/LISTE CM 2014.xls failed: Aucun fichier ou dossier de ce type: discarding ino 2902651925
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/05-Déclaration CNIL/MAIRIE D'AMBOISE- déclarations cnil.pdf failed: Aucun fichier ou dossier de ce type: discarding ino 2902661038
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Schema parapheur.odg failed: Aucun fichier ou dossier de ce type: discarding ino 2902843987
xfsrestore: drive 1: WARNING: attempt to link orphanage/2952829025.3301423651 to var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Collecte d'informations Amboise.xlsx.v1459347620 failed: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: attempt to link orphanage/2952829054.3301423650 to var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/02-Compte rendu de réunions/Compte rendu réunion 3 mai 2016.odt.v1462343392 failed: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: attempt to link orphanage/2952829055.3301423651 to var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/02-Compte rendu de réunions/Compte rendu réunion 3 mai 2016.odt.v1462362656 failed: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: attempt to link orphanage/2952829056.3301423653 to var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Planification.gan.v1462378955 failed: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: attempt to link orphanage/2952829057.3301423651 to var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/04-Etude réseau/Schema réseau actualisé.png.v1462361172 failed: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: attempt to link orphanage/2952829058.3301423651 to var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/02-Compte rendu de réunions/Compte rendu réunion 3 mai 2016.odt.v1462365141 failed: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: attempt to link orphanage/2952829059.3301423650 to var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/02-Compte rendu de réunions/Compte rendu réunion 3 mai 2016.odt.v1462349557 failed: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: attempt to link orphanage/2952829061.3301423650 to var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/02-Compte rendu de réunions/Compte rendu réunion 3 mai 2016.pdf.v1462362659 failed: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: attempt to link orphanage/2952829062.3301423650 to var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/02-Compte rendu de réunions/Compte rendu réunion 3 mai 2016.odt.v1462365509 failed: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: attempt to link orphanage/2952829063.3301423650 to var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/02-Compte rendu de réunions/Compte rendu réunion 3 mai 2016.pdf.v1462365556 failed: Aucun fichier ou dossier de ce type
xfsrestore: drive 1: WARNING: open of var/www/html/owncloud/data/F1000buv/files_versions/Dossier personnel et source de partage/E-Administration/09 Questionnaires communes solære/Dossiers des collectivités/37003 - Amboise/03-Initialisation du site/Documents d'initialisation idélibre/LISTE CM 2014.xls.v1462951463 failed: Aucun fichier ou dossier de ce type: discarding ino 2952829070
xfsrestore: drive 1: WARNING: unable to rmdir /mnt/restore//orphanage: Le dossier n'est pas vide
xfsrestore: restore complete: 610 seconds elapsed
xfsrestore: Restore Summary:
xfsrestore:   stream 0 /mnt/backup-owncloud/xfsdump/owncloud-+-L0-2016-05-07-02-10.dump OK (success)
xfsrestore:   stream 1 /mnt/backup-owncloud/xfsdump/owncloud-+-L1-2016-05-29-02-10.dump OK (success)
xfsrestore: Restore Status: SUCCESS

The restoration is inconsistent.
Some folders are not restored at the right place.
And they are a lots of missing files in some directories.
Is this a bug in xfsdump/xfsrestore ?
Any help would be appreciated.

I use CentOS 7.2 and xfsdump-3.1.4-1.el7.x86_64.

Regards.

--
Damien Gombault
</pre>
  </body>
</html>

--------------A21625E3864E2E4E4F99257C--


--===============3379999186296809403==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3379999186296809403==--
