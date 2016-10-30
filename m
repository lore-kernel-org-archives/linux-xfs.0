Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:36839 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754189AbcJ3Uge (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 30 Oct 2016 16:36:34 -0400
Received: by mail-wm0-f54.google.com with SMTP id p190so113182230wmp.1
        for <linux-xfs@vger.kernel.org>; Sun, 30 Oct 2016 13:36:33 -0700 (PDT)
MIME-Version: 1.0
From: "Steffen D." <sdumke@gmail.com>
Date: Sun, 30 Oct 2016 21:36:32 +0100
Message-ID: <CAPvv1vytjK-n7Z3=Zi+vScuV-ej3CagQ5rFc9ppVC8JEihZPkQ@mail.gmail.com>
Subject: mounting a xfs file system gives the message: "failure code -3003"
 and "structure needs cleaning"
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hello list!

I'll try to explain my problem:

mounting a xfs file system gives the message:
"failure code -3003" and "structure needs cleaning"

xfs_repair /dev/sda4 does not work
"inux-ibbi:/home/steffen # xfs_repair /dev/sda4
Phase 1 - Superblock finden und =C3=BCberpr=C3=BCfen...
Phase 2 - ein internes Protokoll benutzen
        - Null-Protokoll...
FEHLER: Das Dateisystem hat wertvolle Metadaten-=C3=84nderungen in einem
Protokoll, das wiederholt werden sollte. H=C3=A4ngen Sie das Dateisystem ei=
n,
um das Protokoll zu wiederholen und h=C3=A4ngen Sie es wieder aus um
xfs_repair erneut auszuf=C3=BChren. Wenn Sie au=C3=9Fer Stande sind, das
Dateisystem einzuh=C3=A4ngen, benutzen Sie die -L-Option um das Protokoll z=
u
zerst=C3=B6ren und versuchen Sie eine Reparatur.
Beachten Sie, dass die Zerst=C3=B6rung des Protokolls Schaden verursachen
kann -- bitte versuchen sie das Dateisystem einzuh=C3=A4ngen ehe Sie dies t=
un."

xfs_repair -n /dev/sda4 said:
"linux-ibbi:/home/steffen # xfs_repair -n /dev/sda4
Phase 1 - Superblock finden und =C3=BCberpr=C3=BCfen...
Phase 2 - ein internes Protokoll benutzen
        - freier Speicher und Inode-Karten des Dateisystems werden
gescannt...
Metadata corruption detected at block 0x1a1d6001/0x200
flfirst 118 in agf 2 too large (max =3D 118)
agf 118 freelist blocks bad, skipping freelist scan
Metadata corruption detected at block 0x272c1001/0x200
flfirst 118 in agf 3 too large (max =3D 118)
agf 118 freelist blocks bad, skipping freelist scan
agi unlinked bucket 51 is 61133235 in ag 2 (inode=3D598004147)
sb_icount 349952, counted 357504
sb_ifree 9426, counted 7433
sb_fdblocks 9895143, counted 9426793
        - Wurzel-Inode-St=C3=BCck gefunden
Phase 3 - f=C3=BCr jedes AG...
        - agi unverkn=C3=BCpfte Listen werden gescannt (aber nicht bereinig=
t...
        - bekannte Inodes werden behandelt und Inode-Entdeckung wird
durchgef=C3=BChrt...
        - agno =3D 0
        - agno =3D 1
        - agno =3D 2
        - agno =3D 3
        - neu entdeckte Inodes werden behandelt...
Phase 4 - auf doppelte Bl=C3=B6cke =C3=BCberpr=C3=BCfen...
        - Liste mit doppeltem Ausma=C3=9F wird eingerichtet...
        - es wird gepr=C3=BCft ob Inodes Blocks doppelt beanspruchen...
        - agno =3D 1
        - agno =3D 2
        - agno =3D 3
        - agno =3D 0
Kein Ver=C3=A4nderungskennzeichen gesetzt, Phase 5 wird =C3=BCbersprungen
Phase 6 - Inode-Verbindbarkeit wird gepr=C3=BCft...
        - Dateisystem wird durchquert ...
        - durchqueren beendet ...
        - nicht verbundene Inodes werden nach lost+found verschoben ...
disconnected inode 598004147, k=C3=B6nnte zu lost+found gehen
Phase 7 - Verweisanzahl wird gepr=C3=BCft
would have reset inode 598004147 nlinks from 0 to 1
Kein =C3=84nderungskennzeichen gesetzt, Leeren des Dateisystems wird
=C3=BCbersprungen und es wird beendet"

Do I really need to use xfs_repair-L ?

Thank you and best regards

Steffen



-- 
Signatur ausser Betrieb.
